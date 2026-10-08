//! COM/OLE bindings + BUSY session helpers (32-bit x86 Windows only).
//! Talks to BUSY ERP's in-proc automation server (e.g. Busy2L21.CFixedInterface)
//! through raw IDispatch, exposing every method of every registered BUSY class.
const std = @import("std");
const json = @import("json.zig");

pub const Allocator = std.mem.Allocator;

// ---------------- win32 externs ----------------

const GUID = extern struct {
    Data1: u32,
    Data2: u16,
    Data3: u16,
    Data4: [8]u8,
};

const IID_NULL = GUID{ .Data1 = 0, .Data2 = 0, .Data3 = 0, .Data4 = @splat(0) };

extern "ole32" fn CoInitializeEx(?*anyopaque, u32) callconv(.winapi) i32;
extern "ole32" fn CoUninitialize() callconv(.winapi) void;
extern "ole32" fn CoCreateInstance(
    *const GUID,
    ?*anyopaque,
    u32,
    *const GUID,
    *?*anyopaque,
) callconv(.winapi) i32;
extern "ole32" fn CLSIDFromProgID([*:0]const u16, *GUID) callconv(.winapi) i32;
extern "ole32" fn CLSIDFromString([*:0]const u16, *GUID) callconv(.winapi) i32;

extern "oleaut32" fn VariantClear(*VARIANT) callconv(.winapi) i32;
extern "oleaut32" fn SysAllocString([*:0]const u16) callconv(.winapi) ?[*:0]u16;
extern "oleaut32" fn SysFreeString(?[*:0]const u16) callconv(.winapi) void;
extern "oleaut32" fn SysStringLen(?[*:0]const u16) callconv(.winapi) u32;
extern "oleaut32" fn GetErrorInfo(u32, *?*IErrorInfo) callconv(.winapi) i32;

const COINIT_APARTMENTTHREADED: u32 = 0x2;
const CLSCTX_INPROC_SERVER: u32 = 0x1;
const S_OK: i32 = 0;
const DISP_E_PARAMNOTFOUND: i32 = @bitCast(@as(u32, 0x80020003));
const DISP_E_EXCEPTION: i32 = @bitCast(@as(u32, 0x80020009));

// ---------------- VARIANT ----------------

pub const VT_EMPTY: u16 = 0;
pub const VT_NULL: u16 = 1;
pub const VT_I2: u16 = 2;
pub const VT_I4: u16 = 3;
pub const VT_R4: u16 = 4;
pub const VT_R8: u16 = 5;
pub const VT_BSTR: u16 = 8;
pub const VT_DISPATCH: u16 = 9;
pub const VT_ERROR: u16 = 10;
pub const VT_BOOL: u16 = 11;
pub const VT_VARIANT: u16 = 12;
pub const VT_UNKNOWN: u16 = 13;
pub const VT_UI4: u16 = 19;
pub const VT_I8: u16 = 20;
pub const VT_INT: u16 = 22;
pub const VT_UINT: u16 = 23;
pub const VT_HRESULT: u16 = 25;
pub const VT_BYREF: u16 = 0x4000;

pub const VARIANT = extern struct {
    vt: u16,
    r1: u16 = 0,
    r2: u16 = 0,
    r3: u16 = 0,
    data: extern union {
        llVal: i64,
        lVal: i32,
        intVal: i32,
        uintVal: u32,
        bstrVal: ?[*:0]u16,
        boolVal: i16,
        fltVal: f32,
        dblVal: f64,
        scode: i32,
        byref: ?*anyopaque,
        pdispVal: ?*anyopaque,
        punkVal: ?*anyopaque,
    } align(8),

    pub fn init() VARIANT {
        return .{ .vt = VT_EMPTY, .data = undefined };
    }
};

const DISPPARAMS = extern struct {
    rgvarg: ?*VARIANT,
    rgdispidNamedArgs: ?*i32,
    cArgs: u32,
    cNamedArgs: u32,
};

// ---------------- interfaces ----------------

const IErrorInfo = struct {
    vtbl: *const Vtbl,
    const Vtbl = extern struct {
        QueryInterface: *const fn (*IErrorInfo, *const GUID, *?*anyopaque) callconv(.winapi) i32,
        AddRef: *const fn (*IErrorInfo) callconv(.winapi) u32,
        Release: *const fn (*IErrorInfo) callconv(.winapi) u32,
        GetGUID: *const fn (*IErrorInfo, *GUID) callconv(.winapi) i32,
        GetSource: *const fn (*IErrorInfo, *?[*:0]u16) callconv(.winapi) i32,
        GetDescription: *const fn (*IErrorInfo, *?[*:0]u16) callconv(.winapi) i32,
        GetHelpFile: *const fn (*IErrorInfo, *?[*:0]u16) callconv(.winapi) i32,
        GetHelpContext: *const fn (*IErrorInfo, *u32) callconv(.winapi) i32,
    };
};

pub const IDispatch = struct {
    // align(1): BUSY hands out interface pointers from packed heap arrays
    // (observed 2-aligned Field objects). x86 executes unaligned loads fine;
    // declared alignment 1 keeps Zig's safety checks from panicking on them.
    vtbl: *const Vtbl align(1),
    const Vtbl = extern struct {
        QueryInterface: *const fn (*IDispatch, *const GUID, *?*anyopaque) callconv(.winapi) i32,
        AddRef: *const fn (*IDispatch) callconv(.winapi) u32,
        Release: *const fn (*IDispatch) callconv(.winapi) u32,
        GetTypeInfoCount: *const fn (*IDispatch, *u32) callconv(.winapi) i32,
        GetTypeInfo: *const fn (*IDispatch, u32, u32, *?*ITypeInfo) callconv(.winapi) i32,
        GetIDsOfNames: *const fn (*IDispatch, *const GUID, [*][*:0]const u16, u32, u32, *i32) callconv(.winapi) i32,
        Invoke: *const fn (
            *IDispatch,
            i32,
            *const GUID,
            u32,
            u16,
            *DISPPARAMS,
            *VARIANT,
            ?*anyopaque,
            ?*u32,
        ) callconv(.winapi) i32,
    };
};

const ITypeInfo = struct {
    vtbl: *const Vtbl,
    const Vtbl = extern struct {
        QueryInterface: *const fn (*ITypeInfo, *const GUID, *?*anyopaque) callconv(.winapi) i32,
        AddRef: *const fn (*ITypeInfo) callconv(.winapi) u32,
        Release: *const fn (*ITypeInfo) callconv(.winapi) u32,
        GetTypeAttr: *const fn (*ITypeInfo, *?*u8) callconv(.winapi) i32,
        GetTypeComp: *const fn (*ITypeInfo, *?*anyopaque) callconv(.winapi) i32,
        GetFuncDesc: *const fn (*ITypeInfo, u16, *?*u8) callconv(.winapi) i32,
        GetVarDesc: *const fn (*ITypeInfo, u16, *?*u8) callconv(.winapi) i32,
        GetNames: *const fn (*ITypeInfo, i32, [*]?[*:0]u16, u32, *u32) callconv(.winapi) i32,
        GetRefTypeOfImplType: *const fn (*ITypeInfo, u16, *u16) callconv(.winapi) i32,
        GetImplTypeFlags: *const fn (*ITypeInfo, u16, *i32) callconv(.winapi) i32,
        GetIDsOfNamesI: *const fn (*ITypeInfo, [*][*:0]const u16, u32, [*]i32) callconv(.winapi) i32,
        InvokeFunc: *const fn (*ITypeInfo, ?*anyopaque, i32, u16, *DISPPARAMS, *VARIANT, *i32) callconv(.winapi) i32,
        GetDocumentation: *const fn (*ITypeInfo, i32, *?[*:0]u16, *?[*:0]u16, *u32, *?[*:0]u16) callconv(.winapi) i32,
        GetDllEntry: *const fn (*ITypeInfo, i32, u16, u32, *?[*:0]u16, *?[*:0]u16, *u16) callconv(.winapi) i32,
        GetRefTypeInfo: *const fn (*ITypeInfo, u16, *?*ITypeInfo) callconv(.winapi) i32,
        AddressOfMember: *const fn (*ITypeInfo, i32, u16, *?*anyopaque) callconv(.winapi) i32,
        CreateInstance: *const fn (*ITypeInfo, *const GUID, *?*anyopaque) callconv(.winapi) i32,
        GetMops: *const fn (*ITypeInfo, i32, *?[*:0]u16) callconv(.winapi) i32,
        GetContainingTypeLib: *const fn (*ITypeInfo, *?*anyopaque, *u32) callconv(.winapi) i32,
        ReleaseTypeAttr: *const fn (*ITypeInfo, *u8) callconv(.winapi) void,
        ReleaseFuncDesc: *const fn (*ITypeInfo, *u8) callconv(.winapi) void,
        ReleaseVarDesc: *const fn (*ITypeInfo, *u8) callconv(.winapi) void,
    };
};

// ---------------- utf16 helpers ----------------

fn toUtf16(alloc: Allocator, s: []const u8) ![:0]u16 {
    return try std.unicode.utf8ToUtf16LeAllocZ(alloc, s);
}

fn fromUtf16(alloc: Allocator, w: [*:0]u16, len: usize) ![]u8 {
    return try std.unicode.utf16LeToUtf8Alloc(alloc, w[0..len]);
}

// ---------------- surface introspection ----------------

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

// ---------------- session ----------------

pub const Session = struct {
    alloc: Allocator,
    com_inited: bool = false,
    disp: ?*IDispatch = null,
    err_buf: [1024]u8 = undefined,
    err_len: usize = 0,

    pub fn init(alloc: Allocator) !Session {
        var s = Session{ .alloc = alloc };
        const hr = CoInitializeEx(null, COINIT_APARTMENTTHREADED);
        if (hr < 0 and hr != @as(i32, @bitCast(@as(u32, 0x80010106)))) { // RPC_E_CHANGED_MODE ok
            s.setErr("CoInitializeEx failed 0x{x}", .{@as(u32, @bitCast(hr))});
            return error.ComInit;
        }
        s.com_inited = true;
        return s;
    }

    pub fn setErr(self: *Session, comptime fmt: []const u8, args: anytype) void {
        const msg = std.fmt.bufPrint(&self.err_buf, fmt, args) catch return;
        self.err_len = msg.len;
    }

    pub fn lastError(self: *const Session) []const u8 {
        return self.err_buf[0..self.err_len];
    }

    /// Read description of last COM error (IErrorInfo) into err_buf.
    fn loadErrorInfo(self: *Session) void {
        var ei: ?*IErrorInfo = null;
        _ = GetErrorInfo(0, &ei);
        if (ei) |info| {
            defer _ = info.vtbl.Release(info);
            var bstr: ?[*:0]u16 = null;
            if (info.vtbl.GetDescription(info, &bstr) >= 0) {
                if (bstr) |b| {
                    const len = SysStringLen(b);
                    defer SysFreeString(b);
                    const msg = fromUtf16(self.alloc, b, len) catch return;
                    defer self.alloc.free(msg);
                    const m = std.fmt.bufPrint(&self.err_buf, "{s}", .{msg}) catch return;
                    self.err_len = m.len;
                    return;
                }
            }
        }
        self.setErr("COM call failed (no IErrorInfo)", .{});
    }

    pub fn create(self: *Session, prog_id: []const u8) !void {
        const wide_id = try toUtf16(self.alloc, prog_id);
        defer self.alloc.free(wide_id);
        var clsid = GUID{ .Data1 = 0, .Data2 = 0, .Data3 = 0, .Data4 = @splat(0) };
        var hr = CLSIDFromProgID(wide_id.ptr, &clsid);
        if (hr < 0) {
            self.setErr("CLSIDFromProgID('{s}') failed 0x{x}", .{ prog_id, @as(u32, @bitCast(hr)) });
            return error.Clsid;
        }
        const iid_disp = try self.iid("{00020400-0000-0000-C000-000000000046}");
        var p: ?*anyopaque = null;
        hr = CoCreateInstance(&clsid, null, CLSCTX_INPROC_SERVER, &iid_disp, &p);
        if (hr < 0 or p == null) {
            self.setErr("CoCreateInstance('{s}') failed 0x{x}", .{ prog_id, @as(u32, @bitCast(hr)) });
            return error.Create;
        }
        self.disp = @ptrCast(@alignCast(p));
    }

    fn iid(self: *Session, comptime s: []const u8) !GUID {
        _ = self;
        var wide: [40]u16 = undefined;
        if (s.len >= 40) return error.BadGuid;
        for (s[0..s.len], 0..) |c, i| wide[i] = c;
        wide[s.len] = 0;
        var g = GUID{ .Data1 = 0, .Data2 = 0, .Data3 = 0, .Data4 = @splat(0) };
        const hr = CLSIDFromString(@ptrCast(&wide), &g);
        if (hr < 0) return error.BadGuid;
        return g;
    }

    pub fn deinit(self: *Session) void {
        if (self.disp) |d| {
            _ = d.vtbl.Release(d);
            self.disp = null;
        }
        if (self.com_inited) {
            CoUninitialize();
            self.com_inited = false;
        }
    }

    // ---- introspection ----

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

    // ---- invocation ----

    pub const CallResult = struct {
        ret: json.Value,
        outs: []json.Value,

        pub fn deinit(self: *CallResult, alloc: Allocator) void {
            self.ret.deinit(alloc);
            for (self.outs) |*o| o.deinit(alloc);
            alloc.free(self.outs);
        }
    };

    fn toWideFixed(self: *Session, name: []const u8, buf: []u16) !usize {
        _ = self;
        if (name.len + 1 > buf.len) return error.NameTooLong;
        for (name, 0..) |c, i| {
            if (c > 0x7f) return error.NonAsciiName;
            buf[i] = c;
        }
        buf[name.len] = 0;
        return name.len;
    }

    /// Invoke method by name. JSON args are mapped to Variant params;
    /// `{"$byref": value}` objects become VT_BYREF|VT_VARIANT out-params and
    /// their post-call values are returned in `outs`.
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

        var storage = try self.alloc.alloc(VARIANT, @intCast(n));
        defer self.alloc.free(storage);
        var byref_slots = try self.alloc.alloc(VARIANT, @intCast(n));
        defer self.alloc.free(byref_slots);
        var is_byref = try self.alloc.alloc(bool, @intCast(n));
        defer self.alloc.free(is_byref);
        for (0..@as(usize, @intCast(n))) |i| {
            storage[i] = VARIANT.init();
            byref_slots[i] = VARIANT.init();
            is_byref[i] = false;
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
                    if (a.get("$byref")) |inner| {
                        try self.variantFromValue(inner, &byref_slots[i]);
                        storage[i].vt = VT_BYREF | VT_VARIANT;
                        storage[i].data.byref = &byref_slots[i];
                        is_byref[i] = true;
                        filled += 1;
                        continue;
                    }
                }
                try self.variantFromValue(&a, &storage[i]);
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

        const ret = try self.valueFromVariant(&result);
        _ = VariantClear(&result);

        var outs: std.ArrayList(json.Value) = .empty;
        errdefer {
            for (outs.items) |*o| o.deinit(self.alloc);
            outs.deinit(self.alloc);
        }
        for (0..@as(usize, @intCast(n))) |i| {
            if (is_byref[i]) {
                const v = try self.valueFromVariant(&byref_slots[i]);
                _ = VariantClear(&byref_slots[i]);
                try outs.append(self.alloc, v);
            } else {
                _ = VariantClear(&storage[i]);
            }
        }
        return .{ .ret = ret, .outs = try outs.toOwnedSlice(self.alloc) };
    }

    fn memberParamCount(self: *Session, dispid: i32) !i32 {
        const d = self.disp orelse return error.NoDispatch;
        var tc: u32 = 0;
        if (d.vtbl.GetTypeInfoCount(d, &tc) < 0 or tc == 0) return 0;
        var ti: ?*ITypeInfo = null;
        if (d.vtbl.GetTypeInfo(d, 0, 0, &ti) < 0) return 0;
        const info = ti orelse return 0;
        defer _ = info.vtbl.Release(info);

        var ta: ?*u8 = null;
        if (info.vtbl.GetTypeAttr(info, &ta) < 0) return 0;
        const attr = ta orelse return 0;
        const c_funcs = @as(*align(1) const u16, @ptrFromInt(@intFromPtr(attr) + 44)).*;
        info.vtbl.ReleaseTypeAttr(info, attr);

        var i: u16 = 0;
        while (i < c_funcs) : (i += 1) {
            var fd: ?*u8 = null;
            if (info.vtbl.GetFuncDesc(info, i, &fd) < 0) continue;
            const desc = fd orelse continue;
            defer info.vtbl.ReleaseFuncDesc(info, desc);
            const memid = @as(*align(1) const i32, @ptrCast(desc)).*;
            if (memid == dispid) {
                // FUNCDESC x86: cParams (SHORT) at offset 24
                return @as(*align(1) const i16, @ptrFromInt(@intFromPtr(desc) + 24)).*;
            }
        }
        return 0;
    }

    // ---- variant conversion ----

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
                return self.valueFromVariant(inner);
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
            VT_BOOL => return .{ .bool = vv.data.boolVal != 0 },
            VT_BSTR => {
                const b = vv.data.bstrVal orelse return .null;
                const len = SysStringLen(b);
                const s = fromUtf16(self.alloc, b, len) catch return error.OutOfMemory;
                return .{ .str = s };
            },
            VT_DISPATCH, VT_UNKNOWN => {
                return json.Value{ .str = "<dispatch>" };
            },
            VT_ERROR => return .null,
            else => return .null,
        }
    }

    // ---- recordset helpers ----

    fn getDisp(self: *Session, obj: *IDispatch, name: []const u8, flag: u16, args: []const VARIANT) !?*IDispatch {
        var wname: [256]u16 = undefined;
        _ = try self.toWideFixed(name, &wname);
        var names: [1][*:0]const u16 = .{@ptrCast(&wname)};
        var dispid: i32 = 0;
        var hr = obj.vtbl.GetIDsOfNames(obj, &IID_NULL, &names, 1, 0, &dispid);
        if (hr < 0) return error.NoSuchMember;

        var storage: [4]VARIANT = undefined;
        if (args.len > 4) return error.TooManyArgs;
        for (0..args.len) |i| storage[i] = args[args.len - 1 - i];

        var dp = DISPPARAMS{
            .rgvarg = if (args.len > 0) &storage[0] else null,
            .rgdispidNamedArgs = null,
            .cArgs = @intCast(args.len),
            .cNamedArgs = 0,
        };
        var result = VARIANT.init();
        hr = obj.vtbl.Invoke(obj, dispid, &IID_NULL, 0, flag, &dp, &result, null, null);
        if (hr < 0) {
            _ = VariantClear(&result);
            if (hr == DISP_E_EXCEPTION) self.loadErrorInfo();
            return error.InvokeFailed;
        }
        // Ownership: on VT_DISPATCH the variant's reference transfers to the
        // caller (must NOT VariantClear here — callers Release explicitly).
        if (result.vt == VT_DISPATCH) {
            const p = result.data.pdispVal;
            return @ptrCast(@alignCast(p));
        }
        defer _ = VariantClear(&result);
        if (result.vt == VT_UNKNOWN) {
            var p: ?*anyopaque = null;
            const iid_disp = try self.iid("{00020400-0000-0000-C000-000000000046}");
            const unk: *anyopaque = result.data.punkVal orelse return null;
            const qih = @as(*const *const fn (*anyopaque, *const GUID, *?*anyopaque) callconv(.winapi) i32, @ptrCast(@alignCast(unk))).*;
            if (qih(unk, &iid_disp, &p) >= 0 and p != null) return @ptrCast(@alignCast(p));
        }
        return null;
    }

    /// Convenience: run SQL through the object's GetRecordset and return rows as JSON.
    pub fn queryToJson(self: *Session, sql: []const u8) !json.Value {
        const d = self.disp orelse return error.NoDispatch;
        var sql_v = VARIANT.init();
        try self.variantFromValue(&.{ .str = sql }, &sql_v);
        defer _ = VariantClear(&sql_v);

        // GetRecordset(sql)
        var wname: [64]u16 = undefined;
        _ = try self.toWideFixed("GetRecordset", &wname);
        var names: [1][*:0]const u16 = .{@ptrCast(&wname)};
        var dispid: i32 = 0;
        if (d.vtbl.GetIDsOfNames(d, &IID_NULL, &names, 1, 0, &dispid) < 0) return error.NoSuchMember;
        var one = sql_v;
        var dp = DISPPARAMS{ .rgvarg = &one, .rgdispidNamedArgs = null, .cArgs = 1, .cNamedArgs = 0 };
        var result = VARIANT.init();
        const hr = d.vtbl.Invoke(d, dispid, &IID_NULL, 0, 1, &dp, &result, null, null);
        if (hr < 0) {
            _ = VariantClear(&result);
            if (hr == DISP_E_EXCEPTION) self.loadErrorInfo() else self.setErr("GetRecordset failed 0x{x}", .{@as(u32, @bitCast(hr))});
            return error.QueryFailed;
        }
        defer _ = VariantClear(&result);

        const rs = blk: {
            if (result.vt == VT_DISPATCH) {
                const p = result.data.pdispVal;
                // transfer the variant's reference to rso; neuter so the
                // deferred VariantClear doesn't double-release
                result.vt = VT_EMPTY;
                break :blk @as(?*IDispatch, @ptrCast(@alignCast(p)));
            }
            if (result.vt == VT_UNKNOWN) {
                var p: ?*anyopaque = null;
                const iid_disp = try self.iid("{00020400-0000-0000-C000-000000000046}");
                const unk: *anyopaque = result.data.punkVal orelse break :blk null;
                const qih = @as(*const *const fn (*anyopaque, *const GUID, *?*anyopaque) callconv(.winapi) i32, @ptrCast(@alignCast(unk))).*;
                if (qih(unk, &iid_disp, &p) >= 0) break :blk @as(?*IDispatch, @ptrCast(@alignCast(p)));
            }
            break :blk null;
        };
        const rso = rs orelse {
            self.setErr("GetRecordset returned vt={d} (no recordset)", .{result.vt});
            return error.NoRecordset;
        };
        defer _ = rso.vtbl.Release(rso);

        return self.recordsetToJson(rso);
    }

    pub fn recordsetToJson(self: *Session, rs: *IDispatch) !json.Value {
        const alloc = self.alloc;
        // Fields
        const fields = (try self.getDisp(rs, "Fields", 2, &.{})) orelse return error.NoFields;
        defer _ = fields.vtbl.Release(fields);

        // Count
        var count: i64 = 0;
        {
            var wname: [32]u16 = undefined;
            _ = try self.toWideFixed("Count", &wname);
            var names: [1][*:0]const u16 = .{@ptrCast(&wname)};
            var dispid: i32 = 0;
            if (fields.vtbl.GetIDsOfNames(fields, &IID_NULL, &names, 1, 0, &dispid) >= 0) {
                var dp = DISPPARAMS{ .rgvarg = null, .rgdispidNamedArgs = null, .cArgs = 0, .cNamedArgs = 0 };
                var result = VARIANT.init();
                if (fields.vtbl.Invoke(fields, dispid, &IID_NULL, 0, 2, &dp, &result, null, null) >= 0) {
                    const v = try self.valueFromVariant(&result);
                    _ = VariantClear(&result);
                    switch (v) {
                        .int => |i| count = i,
                        else => {
                            var vv = v;
                            vv.deinit(alloc);
                        },
                    }
                }
            }
        }

        // column names: Fields.Item(i).Name
        var col_names = try alloc.alloc([]const u8, @intCast(@max(count, 0)));
        defer {
            for (col_names) |n| alloc.free(n);
            alloc.free(col_names);
        }
        var ci: i64 = 0;
        while (ci < count) : (ci += 1) {
            const f = (try self.itemDispatch(fields, ci)) orelse {
                col_names[@intCast(ci)] = try alloc.dupe(u8, "");
                continue;
            };
            defer _ = f.vtbl.Release(f);
            col_names[@intCast(ci)] = try self.propStr(f, "Name");
        }

        // rows
        var rows: std.ArrayList(json.Value) = .empty;
        errdefer {
            for (rows.items) |*r| r.deinit(alloc);
            rows.deinit(alloc);
        }

        // MoveFirst (ignore failure = empty set)
        _ = self.callVoid(rs, "MoveFirst");
        var guard: usize = 0;
        while (guard < 10_000_000) : (guard += 1) {
            if (try self.propBool(rs, "EOF")) break;
            const rn: usize = @intCast(count);
            var row = try alloc.alloc(json.Value.Entry, rn);
            var filled: usize = 0;
            errdefer {
                for (row[0..filled]) |*e| {
                    e.val.deinit(alloc);
                    alloc.free(e.key);
                }
                alloc.free(row);
            }
            // initialize every entry with an owned key copy
            for (0..rn) |k| {
                row[k] = .{ .key = try alloc.dupe(u8, col_names[k]), .val = .null };
                filled = k + 1;
            }
            var i: i64 = 0;
            while (i < count) : (i += 1) {
                const f = (try self.itemDispatch(fields, i)) orelse continue;
                defer _ = f.vtbl.Release(f);
                const val = try self.propVariant(f, "Value");
                row[@intCast(i)].val.deinit(alloc);
                row[@intCast(i)].val = val;
            }
            try rows.append(alloc, .{ .obj = row });
            filled = 0; // ownership moved into `rows`
            _ = self.callVoid(rs, "MoveNext");
        }
        return .{ .arr = try rows.toOwnedSlice(alloc) };
    }

    fn itemDispatch(self: *Session, fields: *IDispatch, idx: i64) !?*IDispatch {
        var idxv = VARIANT.init();
        try self.variantFromValue(&.{ .int = idx }, &idxv);
        defer _ = VariantClear(&idxv);
        return self.getDisp(fields, "Item", 2, &.{idxv});
    }

    fn getVariant(self: *Session, obj: *IDispatch, name: []const u8) !?VARIANT {
        var wname: [64]u16 = undefined;
        _ = try self.toWideFixed(name, &wname);
        var names: [1][*:0]const u16 = .{@ptrCast(&wname)};
        var dispid: i32 = 0;
        if (obj.vtbl.GetIDsOfNames(obj, &IID_NULL, &names, 1, 0, &dispid) < 0) return null;
        var dp = DISPPARAMS{ .rgvarg = null, .rgdispidNamedArgs = null, .cArgs = 0, .cNamedArgs = 0 };
        var result = VARIANT.init();
        const hr = obj.vtbl.Invoke(obj, dispid, &IID_NULL, 0, 2, &dp, &result, null, null);
        if (hr < 0) {
            _ = VariantClear(&result);
            return null;
        }
        return result;
    }

    fn propVariant(self: *Session, obj: *IDispatch, name: []const u8) !json.Value {
        const v = (try self.getVariant(obj, name)) orelse return .null;
        var vv = v;
        defer _ = VariantClear(&vv);
        return self.valueFromVariant(&vv);
    }

    fn propStr(self: *Session, obj: *IDispatch, name: []const u8) ![]const u8 {
        const v = (try self.getVariant(obj, name)) orelse return try self.alloc.dupe(u8, "");
        var vv = v;
        defer _ = VariantClear(&vv);
        const s = try self.valueFromVariant(&vv);
        return switch (s) {
            .str => |t| t,
            else => blk: {
                var s2 = s;
                s2.deinit(self.alloc);
                break :blk try self.alloc.dupe(u8, "");
            },
        };
    }

    fn propBool(self: *Session, obj: *IDispatch, name: []const u8) !bool {
        const v = (try self.getVariant(obj, name)) orelse return true; // missing EOF -> stop
        var vv = v;
        defer _ = VariantClear(&vv);
        if (vv.vt == VT_BOOL) return vv.data.boolVal != 0;
        if (vv.vt == VT_EMPTY) return true;
        const j = try self.valueFromVariant(&vv);
        return switch (j) {
            .bool => |b| b,
            else => blk: {
                var j2 = j;
                j2.deinit(self.alloc);
                break :blk true;
            },
        };
    }

    fn callVoid(self: *Session, obj: *IDispatch, name: []const u8) void {
        var wname: [64]u16 = undefined;
        _ = self.toWideFixed(name, &wname) catch return;
        var names: [1][*:0]const u16 = .{@ptrCast(&wname)};
        var dispid: i32 = 0;
        if (obj.vtbl.GetIDsOfNames(obj, &IID_NULL, &names, 1, 0, &dispid) < 0) return;
        var dp = DISPPARAMS{ .rgvarg = null, .rgdispidNamedArgs = null, .cArgs = 0, .cNamedArgs = 0 };
        var result = VARIANT.init();
        _ = obj.vtbl.Invoke(obj, dispid, &IID_NULL, 0, 1, &dp, &result, null, null);
        _ = VariantClear(&result);
    }
};
