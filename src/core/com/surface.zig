//! Type-library surface: enumerate IDispatch members (name/kind/params).
const std = @import("std");
const Session = @import("session.zig").Session;
const win32 = @import("win32.zig");
const utf16 = @import("utf16.zig");

const Allocator = std.mem.Allocator;
const ITypeInfo = win32.ITypeInfo;
const SysStringLen = win32.SysStringLen;
const SysFreeString = win32.SysFreeString;
const fromUtf16 = utf16.fromUtf16;

pub const Member = struct {
    name: []const u8,
    kind: []const u8, // method | propertyget | propertyput | variable
    nparams: i16,
    nopt: i16,
    params: []const []const u8,
    pub fn deinit(self: *Member, alloc: Allocator) void {
        for (self.params) |p| alloc.free(p);
        alloc.free(self.params);
        alloc.free(self.name);
    }
};

fn invkindName(k: u32) []const u8 {
    return switch (k) {
        1 => "method",
        2 => "propertyget",
        4 => "propertyput",
        8 => "propertyputref",
        else => "unknown",
    };
}

pub const MemberDump = struct {
    name: []const u8,
    nparams: i16,
    /// Raw FUNCDESC bytes (x86) — calibration input for param ELEMDESC
    /// layout (see probe report; live decode of param VARTYPEs).
    fd_raw: [64]u8 = undefined,
    fd_len: usize,
    /// Pointer candidates found inside the FUNCDESC (offset + target
    /// bytes when readable) — locating the param ELEMDESC array.
    ptrs: [4]PtrDump = .{ empty_ptr, empty_ptr, empty_ptr, empty_ptr },
    nptrs: usize = 0,
    /// UDT descriptor for entry0's VT_PTR->USERDEFINED param (the
    /// RepOpt/ICol-class types): name, size, field names.
    udt: ?@import("recordinfo.zig").UdtDesc = null,
    /// Return-type UDT descriptor (fd bytes 32-39: hreftype + vt 29) —
    /// udtAccMast/udtVchData returns carry the JSON save schema fields.
    ret_udt: ?@import("recordinfo.zig").UdtDesc = null,

    pub const PtrDump = struct {
        off: usize = 0,
        readable: bool = false,
        raw: [96]u8 = undefined,
        /// When the pointed TYPEDESC is VT_PTR: bytes of the pointed-to
        /// subtype TYPEDESC (depth-2 decode).
        sub_hex: [16]u8 = undefined,
        has_sub: bool = false,
    };
    const empty_ptr = PtrDump{};

    pub fn deinit(self: *MemberDump, alloc: Allocator) void {
        if (self.udt) |*u| u.deinit(alloc);
        if (self.ret_udt) |*u| u.deinit(alloc);
        alloc.free(self.name);
    }
};

/// Raw FUNCDESC hex dump for members matching `filter` — used to
/// calibrate param ELEMDESC offsets/types (GetAccLedgerJSON tail etc).
pub fn dumpMemberTypes(self: *Session, alloc: Allocator, filter: []const u8) ![]MemberDump {
    const d = self.disp orelse return error.NoDispatch;
    var tc: u32 = 0;
    var hr = d.vtbl.GetTypeInfoCount(d, &tc);
    if (hr < 0 or tc == 0) return error.NoTypeInfo;
    var ti: ?*ITypeInfo = null;
    hr = d.vtbl.GetTypeInfo(d, 0, 0, &ti);
    const info = ti orelse return error.NoTypeInfo;
    defer _ = info.vtbl.Release(info);

    var ta: ?*u8 = null;
    hr = info.vtbl.GetTypeAttr(info, &ta);
    if (hr < 0) return error.TypeAttr;
    const attr = ta orelse return error.TypeAttr;
    const c_funcs = @as(*align(1) const u16, @ptrFromInt(@intFromPtr(attr) + 44)).*;
    info.vtbl.ReleaseTypeAttr(info, attr);

    var out: std.ArrayList(MemberDump) = .empty;
    errdefer {
        for (out.items) |*m| m.deinit(alloc);
        out.deinit(alloc);
    }
    var i: u16 = 0;
    while (i < c_funcs) : (i += 1) {
        var fd: ?*u8 = null;
        hr = info.vtbl.GetFuncDesc(info, i, &fd);
        if (hr < 0) continue;
        const desc = fd orelse continue;
        defer info.vtbl.ReleaseFuncDesc(info, desc);
        const memid = @as(*align(1) const i32, @ptrCast(desc)).*;
        const c_params = @as(*align(1) const i16, @ptrFromInt(@intFromPtr(desc) + 24)).*;

        var names: [4]?[*:0]u16 = @splat(null);
        var got: u32 = 0;
        hr = info.vtbl.GetNames(info, memid, &names, 4, &got);
        if (hr < 0 or got == 0) continue;
        const l = SysStringLen(names[0].?);
        const mname = try fromUtf16(alloc, names[0].?, l);
        SysFreeString(names[0]);
        names[0] = null;
        var k: u32 = 1;
        while (k < got) : (k += 1) {
            if (names[k]) |np| SysFreeString(np);
        }

        if (filter.len == 0 or std.mem.indexOf(u8, mname, filter) != null) {
            var raw: [64]u8 = undefined;
            const src: [*]const u8 = @ptrCast(desc);
            const n = @min(64, FUNCDESC_SCAN);
            @memcpy(raw[0..n], src[0..n]);
            var dump = MemberDump{ .name = mname, .nparams = c_params, .fd_raw = raw, .fd_len = n };
            // Return-type UDT decode (elemdescFunc: hreftype@32, vt@36;
            // udtAccMast/udtVchData returns = the JSON save schema).
            if (n >= 38) {
                const rvt = @as(*align(1) const u16, @ptrFromInt(@intFromPtr(&raw) + 36)).*;
                if (rvt == 29) {
                    const rh: u32 = @as(*align(1) const u32, @ptrFromInt(@intFromPtr(&raw) + 32)).*;
                    dump.ret_udt = @import("recordinfo.zig").describeHreftype(self, alloc, info, rh) catch null;
                }
            }
            // Follow 4-byte pointer candidates (offsets 40..52) — the
            // param ELEMDESC array pointer lives in the FUNCDESC tail.
            var off: usize = 40;
            while (off + 4 <= n and dump.nptrs < dump.ptrs.len) : (off += 4) {
                const cand = @as(*align(1) const u32, @ptrFromInt(@intFromPtr(desc) + off)).*;
                if (cand < 0x10000) continue;
                const p: *const anyopaque = @ptrFromInt(cand);
                if (!win32.readable(p)) continue;
                var tgt: [96]u8 = undefined;
                @memcpy(&tgt, @as([*]const u8, @ptrCast(p))[0..96]);
                var pd = MemberDump.PtrDump{ .off = off, .readable = true, .raw = tgt };
                // Depth-2: entry0 VT_PTR? follow the subtype TYPEDESC.
                const vt0 = @as(*align(1) const u16, @ptrFromInt(@intFromPtr(p) + 4)).*;
                if (vt0 == 26) {
                    const sub = @as(*align(1) const u32, @ptrFromInt(@intFromPtr(p))).*;
                    if (sub > 0x10000) {
                        const sp: *const anyopaque = @ptrFromInt(sub);
                        if (win32.readable(sp)) {
                            @memcpy(&pd.sub_hex, @as([*]const u8, @ptrCast(sp))[0..16]);
                            pd.has_sub = true;
                        }
                    }
                }
                dump.ptrs[dump.nptrs] = pd;
                dump.nptrs += 1;
            }
            // UDT describe: the off52 candidate is the param ELEMDESC
            // array; entry0's VT_PTR target is the pointed TYPEDESC.
            for (dump.ptrs[0..dump.nptrs]) |pt| {
                if (pt.off != 52 or !pt.readable) continue;
                const cand0 = @as(*align(1) const u32, @ptrFromInt(@intFromPtr(desc) + 52)).*;
                if (cand0 > 0x10000) {
                    const tp: *const u8 = @ptrFromInt(cand0);
                    dump.udt = @import("recordinfo.zig").describeParamUdt(self, alloc, info, tp) catch null;
                }
                break;
            }
            try out.append(alloc, dump);
        } else {
            alloc.free(mname);
        }
    }
    return out.toOwnedSlice(alloc);
}

/// Bytes to dump per FUNCDESC (enough for fields + param ELEMDESC ptr).
const FUNCDESC_SCAN: usize = 56;

pub fn surface(self: *Session, alloc: Allocator) ![]Member {
    const d = self.disp orelse return error.NoDispatch;
    var tc: u32 = 0;
    var hr = d.vtbl.GetTypeInfoCount(d, &tc);
    if (hr < 0 or tc == 0) {
        self.setErr("GetTypeInfoCount -> {d}", .{tc});
        return error.NoTypeInfo;
    }
    var ti: ?*ITypeInfo = null;
    hr = d.vtbl.GetTypeInfo(d, 0, 0, &ti);
    const info = ti orelse {
        self.setErr("GetTypeInfo failed 0x{x}", .{@as(u32, @bitCast(hr))});
        return error.NoTypeInfo;
    };
    defer _ = info.vtbl.Release(info);

    // TYPEATTR (x86, from oaidl.h): guid@0, lcid@16, dwReserved@20,
    // memidConstructor@24, memidDestructor@28, lpstrSchema@32,
    // cbSizeInstance@36, typekind@40, cFuncs(WORD)@44.
    var ta: ?*u8 = null;
    hr = info.vtbl.GetTypeAttr(info, &ta);
    if (hr < 0) return error.TypeAttr;
    const attr = ta orelse return error.TypeAttr;
    const c_funcs = @as(*align(1) const u16, @ptrFromInt(@intFromPtr(attr) + 44)).*;
    info.vtbl.ReleaseTypeAttr(info, attr);

    var out: std.ArrayList(Member) = .empty;
    errdefer {
        for (out.items) |*m| m.deinit(alloc);
        out.deinit(alloc);
    }

    var i: u16 = 0;
    while (i < c_funcs) : (i += 1) {
        var fd: ?*u8 = null;
        hr = info.vtbl.GetFuncDesc(info, i, &fd);
        if (hr < 0) continue;
        const desc = fd orelse continue;
        // FUNCDESC x86 (oaidl.h): memid@0, invkind@16, cParams@24(i16), cParamsOpt@26(i16)
        const memid = @as(*align(1) const i32, @ptrCast(desc)).*;
        const invkind = @as(*align(1) const u32, @ptrFromInt(@intFromPtr(desc) + 16)).*;
        const c_params = @as(*align(1) const i16, @ptrFromInt(@intFromPtr(desc) + 24)).*;
        const c_opt = @as(*align(1) const i16, @ptrFromInt(@intFromPtr(desc) + 26)).*;
        defer info.vtbl.ReleaseFuncDesc(info, desc);

        var names: [64]?[*:0]u16 = @splat(null);
        var got: u32 = 0;
        const want: u32 = @min(64, @as(u32, @intCast(@max(c_params, 0))) + 1);
        hr = info.vtbl.GetNames(info, memid, &names, want, &got);
        if (hr < 0 or got == 0) continue;

        var owned = try alloc.alloc([]const u8, got - 1);
        var owned_n: usize = 0;
        errdefer for (owned[0..owned_n]) |p| alloc.free(p);

        const name_len = SysStringLen(names[0].?);
        const mname = try fromUtf16(alloc, names[0].?, name_len);
        SysFreeString(names[0]);
        names[0] = null;

        var pi: u32 = 1;

        while (pi < got) : (pi += 1) {
            if (names[pi]) |np| {
                const l = SysStringLen(np);
                owned[owned_n] = try fromUtf16(alloc, np, l);
                owned_n += 1;
                SysFreeString(np);
                names[pi] = null;
            }
        }
        // free any remaining unfilled nulls safely (already null)
        try out.append(alloc, .{
            .name = mname,
            .kind = invkindName(invkind),
            .nparams = c_params,
            .nopt = c_opt,
            .params = owned[0..owned_n],
        });
    }
    return out.toOwnedSlice(alloc);
}

/// Write the `--types` UDT descriptor JSON fragment (fields as
/// [name,off,vt] triples) — split from raw.zig (size gate).
pub fn writeUdtJson(w_in: anytype, u: *const @import("recordinfo.zig").UdtDesc) !void {
    var w = w_in; // writer methods need mutable self (call site w is const)
    try w.raw(",\"udt\":{\"name\":");
    try w.str(u.name);
    var nbuf: [96]u8 = undefined;
    try w.raw(std.fmt.bufPrint(&nbuf, ",\"size\":{d},\"kind\":{d},\"htype\":{d},\"fields\":[", .{ u.size, u.kind, u.hreftype }) catch unreachable);
    for (u.fields, 0..) |f, fi| {
        if (fi != 0) try w.raw(",");
        try w.str(std.fmt.bufPrint(&nbuf, "[\"{s}\",{d},{d}]", .{ f.name, f.off, f.vt }) catch unreachable);
    }
    try w.raw("]}");
}

/// Same, keyed `ret_udt` — the return-type UDT (JSON save schema).
pub fn writeRetUdtJson(w_in: anytype, u: *const @import("recordinfo.zig").UdtDesc) !void {
    var w = w_in;
    try w.raw(",\"ret_udt\":{\"name\":");
    try w.str(u.name);
    var nbuf: [96]u8 = undefined;
    try w.raw(std.fmt.bufPrint(&nbuf, ",\"size\":{d},\"kind\":{d},\"htype\":{d},\"fields\":[", .{ u.size, u.kind, u.hreftype }) catch unreachable);
    for (u.fields, 0..) |f, fi| {
        if (fi != 0) try w.raw(",");
        try w.str(std.fmt.bufPrint(&nbuf, "[\"{s}\",{d},{d}]", .{ f.name, f.off, f.vt }) catch unreachable);
    }
    try w.raw("]}");
}
