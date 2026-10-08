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
