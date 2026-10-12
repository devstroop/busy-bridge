//! UDT typelib description (011 size-gate split from recordinfo.zig):
//! resolve a param TYPEDESC / HREFTYPE to its UDT ITypeInfo and
//! describe it (name, size, VARDESC field offsets + vtypes) — the
//! layout source the hand-built record instances pack against.
const std = @import("std");
const Session = @import("session.zig").Session;
const win32 = @import("win32.zig");
const utf16 = @import("utf16.zig");

const Allocator = std.mem.Allocator;
const ITypeInfo = win32.ITypeInfo;
const SysStringLen = win32.SysStringLen;
const SysFreeString = win32.SysFreeString;

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
    // Bounded indirection walk (T1): a param TYPEDESC chains zero or
    // more VT_PTR (26) levels before the VT_USERDEFINED (29) leaf —
    // ConfigMobileAppSeries (CFixedInterface1) is deeper than the
    // single-level 26->29 resolve below used to handle. Depth-guard +
    // same-pointer guard keep the walk cycle-safe; any other vt ends it
    // (null = not a UDT param, unchanged contract).
    var td: *const u8 = param_tdesc;
    var hreftype: u32 = 0;
    var found = false;
    var depth: usize = 0;
    while (depth < 4) : (depth += 1) {
        const vt = @as(*align(1) const u16, @ptrFromInt(@intFromPtr(td) + 4)).*;
        if (vt == 29) {
            hreftype = @as(*align(1) const u32, @ptrCast(td)).*;
            found = true;
            break;
        } else if (vt == 26) {
            const next: *const u8 = @ptrFromInt(@as(usize, @intCast(@as(*align(1) const u32, @ptrCast(td)).*)));
            if (next == td) break; // self-pointer cycle
            td = next;
        } else break;
    }
    if (!found) return null;
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
