//! COM invocation: JSON args -> VARIANT marshaling, IDispatch::Invoke,
//! result/out-param values back to JSON.
const std = @import("std");
const json = @import("../../util/json.zig");
const helpers = @import("../../util/helpers.zig");
const Session = @import("session.zig").Session;
const win32 = @import("win32.zig");
const utf16 = @import("utf16.zig");

const Allocator = std.mem.Allocator;
const VARIANT = win32.VARIANT;
const DISPPARAMS = win32.DISPPARAMS;
const IID_NULL = win32.IID_NULL;
const VariantClear = win32.VariantClear;
const SysAllocString = win32.SysAllocString;
const SysStringLen = win32.SysStringLen;
const DISP_E_PARAMNOTFOUND = win32.DISP_E_PARAMNOTFOUND;
const DISP_E_EXCEPTION = win32.DISP_E_EXCEPTION;
const VT_EMPTY = win32.VT_EMPTY;
const VT_NULL = win32.VT_NULL;
const VT_I2 = win32.VT_I2;
const VT_I4 = win32.VT_I4;
const VT_R4 = win32.VT_R4;
const VT_R8 = win32.VT_R8;
const VT_CY = win32.VT_CY;
const VT_DATE = win32.VT_DATE;
const VT_BSTR = win32.VT_BSTR;
const VT_DISPATCH = win32.VT_DISPATCH;
const VT_ERROR = win32.VT_ERROR;
const VT_BOOL = win32.VT_BOOL;
const VT_VARIANT = win32.VT_VARIANT;
const VT_UNKNOWN = win32.VT_UNKNOWN;
const VT_UI4 = win32.VT_UI4;
const VT_I8 = win32.VT_I8;
const VT_INT = win32.VT_INT;
const VT_UINT = win32.VT_UINT;
const VT_HRESULT = win32.VT_HRESULT;
const VT_BYREF = win32.VT_BYREF;
const toUtf16 = utf16.toUtf16;
const fromUtf16 = utf16.fromUtf16;

pub const CallResult = @import("result.zig").CallResult;

/// Invoke method by name. JSON args are mapped to Variant params.
/// Markers (issue #7 M3 — services-class params are TYPED, not Variant):
///   {"$byref": ""}         -> VT_BYREF|VT_VARIANT (As Variant params)
///   {"$byref": "f8"|"i4"|"cy"|"i8"} -> typed out-param boxes (As
///                              Double/Long/Currency/LongLong)
///   {"$date": "YYYY-MM-DD"} -> VT_DATE input (report date params)
/// Typed/Variant post-call values are returned in `outs`.
pub fn invoke(self: *Session, method: []const u8, args: []const json.Value) !CallResult {
    const d = self.disp orelse return error.NoDispatch;
    var wname: [256]u16 = undefined;
    _ = try self.toWideFixed(method, &wname);
    var names: [1][*:0]const u16 = .{@ptrCast(&wname)};
    var dispid: i32 = 0;
    var hr = d.vtbl.GetIDsOfNames(d, &IID_NULL, &names, 1, 0, &dispid);
    if (hr < 0) {
        self.setErr("GetIDsOfNames('{s}') -> 0x{x} (unknown member)", .{ method, @as(u32, @bitCast(hr)) });
        return error.NoSuchMember;
    }

    // Pass exactly the args provided (like VB/PowerShell late binding does).
    // The callee tolerates omitted trailing params; padding with
    // VT_ERROR/DISP_E_PARAMNOTFOUND makes BUSY return E_INVALIDARG.
    const n = args.len;

    const ByrefKind = enum { variant, f8, i4, cy, i8 };
    var storage = try self.alloc.alloc(VARIANT, @intCast(n));
    defer self.alloc.free(storage);
    var byref_slots = try self.alloc.alloc(VARIANT, @intCast(n));
    defer self.alloc.free(byref_slots);
    var is_byref = try self.alloc.alloc(bool, @intCast(n));
    defer self.alloc.free(is_byref);
    var byref_kind = try self.alloc.alloc(ByrefKind, @intCast(n));
    defer self.alloc.free(byref_kind);
    // typed out-param boxes (preallocated; read back after Invoke)
    var f8box = try self.alloc.alloc(f64, @intCast(n));
    defer self.alloc.free(f8box);
    var i4box = try self.alloc.alloc(i32, @intCast(n));
    defer self.alloc.free(i4box);
    var i8box = try self.alloc.alloc(i64, @intCast(n));
    defer self.alloc.free(i8box);
    for (0..@as(usize, @intCast(n))) |i| {
        storage[i] = VARIANT.init();
        byref_slots[i] = VARIANT.init();
        is_byref[i] = false;
        byref_kind[i] = .variant;
        f8box[i] = 0;
        i4box[i] = 0;
        i8box[i] = 0;
    }

    // Fill in logical order; free on error.
    var filled: usize = 0;
    errdefer for (0..filled) |i| {
        if (!is_byref[i]) _ = VariantClear(&storage[i]) else _ = VariantClear(&byref_slots[i]);
    };

    for (0..@as(usize, @intCast(n))) |i| {
        if (i < args.len) {
            const a = args[i];
            if (a == .obj) {
                if (a.get("$date")) |dv| {
                    // VT_DATE input — report methods date-type their params
                    const ole: f64 = switch (dv.*) {
                        .str => |s| helpers.dateToOle(s) orelse {
                            self.setErr("invalid $date '{s}' (YYYY-MM-DD / DD-MM-YYYY)", .{s});
                            return error.BadArgs;
                        },
                        .int => |iv| @floatFromInt(iv),
                        .float => |f| f,
                        else => return error.BadArgs,
                    };
                    storage[i].vt = VT_DATE;
                    storage[i].data.dblVal = ole;
                    filled += 1;
                    continue;
                }
                if (a.get("$byref")) |inner| {
                    if (inner.* == .str and inner.str.len > 0) {
                        // typed box marker (services-class typed params)
                        if (std.mem.eql(u8, inner.str, "f8")) {
                            storage[i].vt = VT_BYREF | VT_R8;
                            storage[i].data.byref = &f8box[i];
                            byref_kind[i] = .f8;
                        } else if (std.mem.eql(u8, inner.str, "i4")) {
                            storage[i].vt = VT_BYREF | VT_I4;
                            storage[i].data.byref = &i4box[i];
                            byref_kind[i] = .i4;
                        } else if (std.mem.eql(u8, inner.str, "cy")) {
                            storage[i].vt = VT_BYREF | VT_CY;
                            storage[i].data.byref = &i8box[i];
                            byref_kind[i] = .cy;
                        } else if (std.mem.eql(u8, inner.str, "i8")) {
                            storage[i].vt = VT_BYREF | VT_I8;
                            storage[i].data.byref = &i8box[i];
                            byref_kind[i] = .i8;
                        } else {
                            self.setErr("unknown $byref marker '{s}' (use \"\", f8, i4, cy, i8)", .{inner.str});
                            return error.BadArgs;
                        }
                        is_byref[i] = true;
                        filled += 1;
                        continue;
                    }
                    try variantFromValue(self, inner, &byref_slots[i]);
                    storage[i].vt = VT_BYREF | VT_VARIANT;
                    storage[i].data.byref = &byref_slots[i];
                    is_byref[i] = true;
                    filled += 1;
                    continue;
                }
            }
            try variantFromValue(self, &a, &storage[i]);
            filled += 1;
        } else {
            // omitted optional parameter
            storage[i].vt = VT_ERROR;
            storage[i].data.scode = DISP_E_PARAMNOTFOUND;
            filled += 1;
        }
    }

    // rgvarg is reversed
    const nn: usize = @intCast(n);
    var reversed = try self.alloc.alloc(VARIANT, nn);
    defer self.alloc.free(reversed);
    for (0..nn) |i| {
        reversed[i] = storage[nn - 1 - i];
    }

    var dp = DISPPARAMS{
        .rgvarg = if (n > 0) &reversed[0] else null,
        .rgdispidNamedArgs = null,
        .cArgs = @intCast(n),
        .cNamedArgs = 0,
    };
    var result = VARIANT.init();
    hr = d.vtbl.Invoke(d, dispid, &IID_NULL, 0, 1, &dp, &result, null, null); // DISPATCH_METHOD
    if (hr < 0) {
        _ = VariantClear(&result);
        if (hr == DISP_E_EXCEPTION) self.loadErrorInfo() else self.setErr("Invoke('{s}') failed 0x{x}", .{ method, @as(u32, @bitCast(hr)) });
        return error.InvokeFailed;
    }

    const ret = try valueFromVariant(self, &result);
    _ = VariantClear(&result);

    var outs: std.ArrayList(json.Value) = .empty;
    errdefer {
        for (outs.items) |*o| o.deinit(self.alloc);
        outs.deinit(self.alloc);
    }
    for (0..@as(usize, @intCast(n))) |i| {
        if (is_byref[i]) {
            const v = switch (byref_kind[i]) {
                .variant => blk: {
                    const vv = try valueFromVariant(self, &byref_slots[i]);
                    _ = VariantClear(&byref_slots[i]);
                    break :blk vv;
                },
                .f8 => json.Value{ .float = f8box[i] },
                .i4 => json.Value{ .int = i4box[i] },
                .cy => json.Value{ .float = @as(f64, @floatFromInt(i8box[i])) / 10000.0 }, // VT_CY scale
                .i8 => json.Value{ .int = i8box[i] },
            };
            try outs.append(self.alloc, v);
        } else {
            _ = VariantClear(&storage[i]);
        }
    }
    return .{ .ret = ret, .outs = try outs.toOwnedSlice(self.alloc) };
}

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
