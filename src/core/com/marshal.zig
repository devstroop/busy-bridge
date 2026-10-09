//! VARIANT <-> JSON marshaling (split from invoke.zig — size gate):
//! the single mapping both directions for COM arguments, results, and
//! out-params. Re-exported via invoke.zig for existing call sites.
const std = @import("std");
const json = @import("../../util/json.zig");
const helpers = @import("../../util/helpers.zig");
const Session = @import("session.zig").Session;
const win32 = @import("win32.zig");
const utf16 = @import("utf16.zig");

const VARIANT = win32.VARIANT;
const VariantClear = win32.VariantClear;
const SysAllocString = win32.SysAllocString;
const SysStringLen = win32.SysStringLen;
const toUtf16 = utf16.toUtf16;
const fromUtf16 = utf16.fromUtf16;
const VT_NULL = win32.VT_NULL;
const VT_I4 = win32.VT_I4;
const VT_I8 = win32.VT_I8;
const VT_R8 = win32.VT_R8;
const VT_DATE = win32.VT_DATE;
const VT_BSTR = win32.VT_BSTR;
const VT_BOOL = win32.VT_BOOL;
const VT_ERROR = win32.VT_ERROR;
const VT_VARIANT = win32.VT_VARIANT;
const VT_EMPTY = win32.VT_EMPTY;
const VT_I2 = win32.VT_I2;
const VT_R4 = win32.VT_R4;
const VT_INT = win32.VT_INT;
const VT_UI4 = win32.VT_UI4;
const VT_UINT = win32.VT_UINT;
const VT_HRESULT = win32.VT_HRESULT;
const VT_DISPATCH = win32.VT_DISPATCH;
const VT_UNKNOWN = win32.VT_UNKNOWN;
const VT_BYREF = win32.VT_BYREF;

pub fn variantFromValue(self: *Session, v: *const json.Value, out: *VARIANT) !void {
    out.* = VARIANT.init();
    switch (v.*) {
        .null => {
            out.vt = VT_NULL;
        },
        .bool => |b| {
            out.vt = VT_BOOL;
            out.data.boolVal = if (b) -1 else 0;
        },
        .int => |i| {
            if (i >= std.math.minInt(i32) and i <= std.math.maxInt(i32)) {
                out.vt = VT_I4;
                out.data.lVal = @intCast(i);
            } else {
                out.vt = VT_I8;
                out.data.llVal = i;
            }
        },
        .float => |f| {
            out.vt = VT_R8;
            out.data.dblVal = f;
        },
        .str => |s| {
            const wide = toUtf16(self.alloc, s) catch return error.OutOfMemory;
            defer self.alloc.free(wide);
            out.vt = VT_BSTR;
            out.data.bstrVal = SysAllocString(wide.ptr);
        },
        .arr, .obj => return error.UnsupportedArgType,
    }
}

pub fn valueFromVariant(self: *Session, vv: *const VARIANT) !json.Value {
    const vt = vv.vt & ~@as(u16, VT_BYREF);
    if (vv.vt & VT_BYREF != 0) {
        // only VT_BYREF|VT_VARIANT handled by caller; others: best effort
        if (vt == VT_VARIANT) {
            const inner: *const VARIANT = @ptrCast(@alignCast(vv.data.byref));
            return valueFromVariant(self, inner);
        }
        return .null;
    }
    switch (vt) {
        VT_EMPTY, VT_NULL => return .null,
        VT_I2 => return .{ .int = @as(*align(1) const i16, @ptrCast(&vv.data.llVal)).* },
        VT_I4, VT_INT, VT_HRESULT => return .{ .int = vv.data.lVal },
        VT_UI4, VT_UINT => return .{ .int = vv.data.uintVal },
        VT_I8 => return .{ .int = vv.data.llVal },
        VT_R4 => return .{ .float = @as(*align(1) const f32, @ptrCast(&vv.data.llVal)).* },
        VT_R8 => return .{ .float = vv.data.dblVal },
        // OLE date (Tran1.Date etc.) — was silently .null before M1;
        // BUSY's display format is DD/MM/YYYY.
        VT_DATE => {
            var b: [16]u8 = undefined;
            return .{ .str = try self.alloc.dupe(u8, try helpers.oleDateToText(&b, vv.data.dblVal)) };
        },
        VT_BOOL => return .{ .bool = vv.data.boolVal != 0 },
        VT_BSTR => {
            const b = vv.data.bstrVal orelse return .null;
            const len = SysStringLen(b);
            const s = fromUtf16(self.alloc, b, len) catch return error.OutOfMemory;
            return .{ .str = s };
        },
        VT_DISPATCH, VT_UNKNOWN => {
            // owned copy: every .str must be allocator-owned (freeing a
            // static literal corrupts the heap — found via
            // GetAllVchSeriesCodes returning a dispatch collection)
            return .{ .str = try self.alloc.dupe(u8, "<dispatch>") };
        },
        VT_ERROR => return .null,
        else => return .null,
    }
}
