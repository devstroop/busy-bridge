//! UDT instancing via IRecordInfo (the VT_RECORD wall — probe report
//! §12): HREFTYPEs resolve through the proven GetRefTypeInfo path
//! (typelib FindName/GetContainingTypeLib are unstable headless);
//! record instances are zeroed, field-filled via VARDESC indices, and
//! handed back as VT_RECORD VARIANTs.
const std = @import("std");
const Session = @import("session.zig").Session;
const win32 = @import("win32.zig");
const utf16 = @import("utf16.zig");
const json = @import("../../util/json.zig");
const marshal = @import("marshal.zig");
const helpers = @import("../../util/helpers.zig");

const Allocator = std.mem.Allocator;
const ITypeInfo = win32.ITypeInfo;
const VARIANT = win32.VARIANT;
const SysStringLen = win32.SysStringLen;
const SysFreeString = win32.SysFreeString;
const SysAllocString = win32.SysAllocString;
const VariantClear = win32.VariantClear;

fn jstr(v: *const json.Value) ?[]const u8 {
    return if (v.* == .str) v.str else null;
}
fn jf64(v: *const json.Value) ?f64 {
    return switch (v.*) {
        .float => |f| f,
        .int => |i| @floatFromInt(i),
        else => null,
    };
}
fn ji64(v: *const json.Value) ?i64 {
    return if (v.* == .int) v.int else null;
}
fn jbool(v: *const json.Value) ?bool {
    return if (v.* == .bool) v.bool else null;
}

/// One UDT field: name + byte offset (VARDESC oInst@+8) + VARTYPE
/// (TYPEDESC@+12 -> vt@+16) — enough to hand-build/read record bytes
/// without IRecordInfo calls (whose vtable is trap-thunked).
pub const FieldDesc = struct {
    name: []u8,
    off: u32,
    vt: u16,
};

pub const UdtDesc = struct {
    name: []u8,
    size: u32,
    /// TKIND (1 = TKIND_RECORD).
    kind: u8,
    /// HREFTYPE (for GetRefTypeInfo-based instancing).
    hreftype: u32,
    fields: []FieldDesc,
    pub fn deinit(self: *UdtDesc, alloc: Allocator) void {
        for (self.fields) |f| alloc.free(f.name);
        alloc.free(self.fields);
        alloc.free(self.name);
    }
};

/// Describe the UDT behind a param TYPEDESC (VT_PTR->USERDEFINED or
/// direct USERDEFINED): name, cbSizeInstance, field names, hreftype.
pub fn describeParamUdt(
    sess: *Session,
    alloc: Allocator,
    ti_method: *ITypeInfo,
    param_tdesc: *const u8,
) !?UdtDesc {
    const vt = @as(*align(1) const u16, @ptrFromInt(@intFromPtr(param_tdesc) + 4)).*;
    var hreftype: u32 = 0;
    if (vt == 29) {
        hreftype = @as(*align(1) const u32, @ptrCast(param_tdesc)).*;
    } else if (vt == 26) {
        const pointed: *const u8 = @ptrFromInt(@as(usize, @intCast(@as(*align(1) const u32, @ptrCast(param_tdesc)).*)));
        const pvt = @as(*align(1) const u16, @ptrFromInt(@intFromPtr(pointed) + 4)).*;
        if (pvt != 29) return null;
        hreftype = @as(*align(1) const u32, @ptrFromInt(@intFromPtr(pointed))).*;
    } else return null;
    return describeHreftype(sess, alloc, ti_method, hreftype);
}

/// Resolve HREFTYPE -> UDT ITypeInfo and describe it.
pub fn describeHreftype(
    sess: *Session,
    alloc: Allocator,
    ti_method: *ITypeInfo,
    hreftype: u32,
) !?UdtDesc {
    var udt_ti: ?*ITypeInfo = null;
    const hr = ti_method.vtbl.GetRefTypeInfo(ti_method, hreftype, &udt_ti);
    const ti = udt_ti orelse {
        sess.setErr("GetRefTypeInfo({d}) failed 0x{x}", .{ hreftype, @as(u32, @bitCast(hr)) });
        return null;
    };
    defer _ = ti.vtbl.Release(ti);
    return describeUdtTi(alloc, ti, hreftype);
}

/// Describe an already-resolved UDT ITypeInfo (name/size/fields with
/// offsets + vtypes).
pub fn describeUdtTi(
    alloc: Allocator,
    ti: *ITypeInfo,
    hreftype: u32,
) !?UdtDesc {
    var hr: i32 = 0;

    var ta: ?*u8 = null;
    hr = ti.vtbl.GetTypeAttr(ti, &ta);
    if (hr < 0) return null;
    const attr = ta orelse return null;
    const size = @as(*align(1) const u32, @ptrFromInt(@intFromPtr(attr) + 36)).*;
    const kind = @as(*align(1) const u8, @ptrFromInt(@intFromPtr(attr) + 40)).*;
    ti.vtbl.ReleaseTypeAttr(ti, attr);

    var n1: ?[*:0]u16 = null;
    var n2: ?[*:0]u16 = null;
    var help: u32 = 0;
    var nf: ?[*:0]u16 = null;
    hr = ti.vtbl.GetDocumentation(ti, -1, &n1, &n2, &help, &nf);
    var udt_name: []u8 = try alloc.dupe(u8, "<udt>");
    if (hr >= 0) {
        if (n1) |np| {
            alloc.free(udt_name);
            udt_name = try utf16.fromUtf16(alloc, np, SysStringLen(np));
            SysFreeString(np);
        }
        if (n2) |np| SysFreeString(np);
        if (nf) |np| SysFreeString(np);
    }

    var fields: std.ArrayList(FieldDesc) = .empty;
    errdefer {
        for (fields.items) |f| alloc.free(f.name);
        fields.deinit(alloc);
    }
    var i: u16 = 0;
    while (i < 256 and fields.items.len < 200) : (i += 1) {
        var vd: ?*u8 = null;
        hr = ti.vtbl.GetVarDesc(ti, i, &vd);
        if (hr < 0) break;
        const desc = vd orelse break;
        defer ti.vtbl.ReleaseVarDesc(ti, desc);
        const memid = @as(*align(1) const i32, @ptrCast(desc)).*;
        const off = @as(*align(1) const u32, @ptrFromInt(@intFromPtr(desc) + 8)).*;
        const fvt = @as(*align(1) const u16, @ptrFromInt(@intFromPtr(desc) + 16)).*;
        var names: [2]?[*:0]u16 = @splat(null);
        var got: u32 = 0;
        hr = ti.vtbl.GetNames(ti, memid, &names, 2, &got);
        if (hr < 0 or got == 0) continue;
        const l = SysStringLen(names[0].?);
        const fname = try utf16.fromUtf16(alloc, names[0].?, l);
        SysFreeString(names[0]);
        names[0] = null;
        if (names[1]) |np| SysFreeString(np);
        try fields.append(alloc, .{ .name = fname, .off = off, .vt = fvt });
    }

    return .{
        .name = udt_name,
        .size = size,
        .kind = kind,
        .hreftype = hreftype,
        .fields = try fields.toOwnedSlice(alloc),
    };
}

/// IRecordInfo for a UDT ITypeInfo (oleaut32 export).
pub fn recordInfoFor(sess: *Session, ti_udt: *ITypeInfo) !*win32.IRecordInfo {
    var ri: ?*anyopaque = null;
    const hr = win32.GetRecordInfoFromTypeInfo(ti_udt, &ri);
    if (hr < 0 or ri == null) {
        sess.setErr("GetRecordInfoFromTypeInfo failed 0x{x}", .{@as(u32, @bitCast(hr))});
        return error.RecordInfo;
    }
    return @ptrCast(@alignCast(ri));
}

/// Live vtable calibration (BUSY_REC_CAL=1): probe IRecordInfo slots
/// 3..17 with (ri, *u32) and print hr/value — GetSize returns the
/// TYPEATTR size (5600 for udtRepOptions), GetFieldCount a small count.
pub fn calibrate(ri: *win32.IRecordInfo) void {
    var s: usize = 3;
    while (s < 18) : (s += 1) {
        var v: u32 = 0;
        const fnp: *const fn (*win32.IRecordInfo, *u32) callconv(.winapi) i32 = @ptrFromInt(@intFromPtr(ri.vtbl) + s * 4);
        const r = fnp(ri, &v);
        std.debug.print("[cal] slot {d}: hr=0x{x} v={d}\n", .{ s, @as(u32, @bitCast(r)), v });
    }
}

/// Hand-build a UDT instance from its layout (VARDESC offsets+vtypes)
/// — the IRecordInfo vtable is trap-thunked headless, so bytes are
/// packed manually. Returns VT_BYREF|VT_RECORD (byref = struct ptr);
/// size is stashed in variant r2 for the caller's cleanup box.
pub fn recordFromUdtTi(
    sess: *Session,
    alloc: Allocator,
    ti_udt: *ITypeInfo,
    hreftype: u32,
    fields: *const json.Value,
) !VARIANT {
    const desc = (try describeUdtTi(alloc, ti_udt, hreftype)) orelse {
        sess.setErr("UDT describe failed", .{});
        return error.RecordInfo;
    };
    var d = desc;
    defer d.deinit(alloc);
    if (d.size == 0 or d.size > (1 << 20)) return error.RecordInfo;

    const buf = alloc.alloc(u8, d.size) catch return error.OutOfMemory;
    errdefer alloc.free(buf);
    @memset(buf, 0);

    if (fields.* == .obj) {
        for (fields.obj) |entry| {
            if (entry.key.len > 0 and entry.key[0] == '$') continue; // $cal etc.
            var fd: ?FieldDesc = null;
            for (d.fields) |f| {
                if (std.mem.eql(u8, f.name, entry.key)) {
                    fd = f;
                    break;
                }
            }
            const f = fd orelse continue;
            const dst: [*]u8 = buf.ptr + f.off;
            switch (f.vt) {
                // VT_BSTR.
                8 => {
                    var wb: [512]u16 = undefined;
                    const s = jstr(&entry.val) orelse continue;
                    const n = sess.toWideFixed(s, &wb) catch continue;
                    wb[n] = 0;
                    const b = SysAllocString(@ptrCast(wb[0..n].ptr));
                    @as(*align(1) ?[*:0]u16, @ptrCast(dst)).* = b;
                },
                // VT_DATE / VT_R8.
                7, 5 => {
                    const v: f64 = if (entry.val == .str)
                        helpers.dateToOle(entry.val.str) orelse jf64(&entry.val) orelse 0
                    else
                        jf64(&entry.val) orelse 0;
                    @as(*align(1) f64, @ptrCast(dst)).* = v;
                },
                // VT_R4.
                4 => {
                    @as(*align(1) f32, @ptrCast(dst)).* = @floatCast(jf64(&entry.val) orelse 0);
                },
                // VT_I4 / VT_INT / VT_ERROR.
                3, 22, 10 => {
                    @as(*align(1) i32, @ptrCast(dst)).* = @intCast((ji64(&entry.val) orelse @as(i64, @intFromFloat(jf64(&entry.val) orelse 0))));
                },
                // VT_I2.
                2 => {
                    @as(*align(1) i16, @ptrCast(dst)).* = @intCast(ji64(&entry.val) orelse 0);
                },
                // VT_BOOL.
                11 => {
                    const b: i16 = if (jbool(&entry.val) orelse false) -1 else 0;
                    @as(*align(1) i16, @ptrCast(dst)).* = b;
                },
                // VT_CY.
                6 => {
                    @as(*align(1) i64, @ptrCast(dst)).* = @intFromFloat((jf64(&entry.val) orelse 0) * 10000.0);
                },
                // VT_UI1.
                17 => {
                    dst[0] = @intCast(ji64(&entry.val) orelse 0);
                },
                else => {}, // unsupported field type skipped
            }
        }
    }

    var out = VARIANT.init();
    // VB6 ByRef-UDT shape: VT_BYREF|VT_VARIANT -> inner VT_RECORD
    // (VB6 Invoke unwraps the pointed variant; bare byref-record and
    // byval-record both 0x80020005 live).
    const ri = try recordInfoFor(sess, ti_udt);
    const box = alloc.create(VARIANT) catch return error.OutOfMemory;
    box.* = VARIANT.init();
    box.vt = win32.VT_RECORD;
    box.data.rec = .{ .pRecValue = buf.ptr, .pRecInfo = ri };
    out.vt = win32.VT_BYREF | win32.VT_VARIANT;
    out.data.byref = box;
    out.r2 = @truncate(d.size); // cleanup size stash (u16)
    return out;
}

/// HREFTYPE-based entry (the proven path): {"$record":{htype,fields}}.
pub fn recordFromHreftype(
    sess: *Session,
    alloc: Allocator,
    hreftype: u32,
    fields: *const json.Value,
) !VARIANT {
    const d = sess.disp orelse return error.NoDispatch;
    var tc: u32 = 0;
    _ = d.vtbl.GetTypeInfoCount(d, &tc);
    if (tc == 0) return error.NoTypeInfo;
    var ti_main: ?*ITypeInfo = null;
    _ = d.vtbl.GetTypeInfo(d, 0, 0, &ti_main);
    const ti = ti_main orelse return error.NoTypeInfo;
    defer _ = ti.vtbl.Release(ti);
    var udt: ?*ITypeInfo = null;
    const hr = ti.vtbl.GetRefTypeInfo(ti, hreftype, &udt);
    const tudt = udt orelse {
        sess.setErr("GetRefTypeInfo({d}) failed 0x{x}", .{ hreftype, @as(u32, @bitCast(hr)) });
        return error.NotFound;
    };
    defer _ = tudt.vtbl.Release(tudt);
    return recordFromUdtTi(sess, alloc, tudt, hreftype, fields);
}
