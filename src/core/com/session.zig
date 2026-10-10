//! COM session: apartment init, object creation, error state, dispatch helpers.
//!
//! The behavior-heavy operations (surface/invoke/query) live in sibling
//! modules and are re-exposed as Session methods through thin wrappers so
//! external call sites (`sess.invoke(...)`) stay stable.
const std = @import("std");
const json = @import("../../util/json.zig");
const win32 = @import("win32.zig");
const utf16 = @import("utf16.zig");
const surface_mod = @import("surface.zig");
const invoke_mod = @import("invoke.zig");

const Allocator = std.mem.Allocator;
const GUID = win32.GUID;
const IDispatch = win32.IDispatch;
const ITypeInfo = win32.ITypeInfo;
const IErrorInfo = win32.IErrorInfo;
const CoInitializeEx = win32.CoInitializeEx;
const CoUninitialize = win32.CoUninitialize;
const CoCreateInstance = win32.CoCreateInstance;
const CLSIDFromProgID = win32.CLSIDFromProgID;
const CLSIDFromString = win32.CLSIDFromString;
const GetErrorInfo = win32.GetErrorInfo;
const SysStringLen = win32.SysStringLen;
const SysFreeString = win32.SysFreeString;
const COINIT_APARTMENTTHREADED = win32.COINIT_APARTMENTTHREADED;
const CLSCTX_INPROC_SERVER = win32.CLSCTX_INPROC_SERVER;
const toUtf16 = utf16.toUtf16;
const fromUtf16 = utf16.fromUtf16;

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

    /// Clear the sticky error (e.g. an expected NoSuchMember probe
    /// before an aux fallback succeeded — leaving it set makes later
    /// failText responses carry a stale message).
    pub fn clearErr(self: *Session) void {
        self.err_len = 0;
    }

    /// Read description of last COM error (IErrorInfo) into err_buf.
    pub fn loadErrorInfo(self: *Session) void {
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

    pub fn iid(self: *Session, comptime s: []const u8) !GUID {
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

    pub fn memberParamCount(self: *Session, dispid: i32) !i32 {
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

    pub fn toWideFixed(self: *Session, name: []const u8, buf: []u16) !usize {
        _ = self;
        if (name.len + 1 > buf.len) return error.NameTooLong;
        for (name, 0..) |c, i| {
            if (c > 0x7f) return error.NonAsciiName;
            buf[i] = c;
        }
        buf[name.len] = 0;
        return name.len;
    }

    // ---- behavior wrappers (impl in sibling modules) ----

    pub fn surface(self: *Session, alloc: Allocator) ![]surface_mod.Member {
        return surface_mod.surface(self, alloc);
    }

    /// Raw FUNCDESC dumps for member(s) matching `filter` — param-type
    /// calibration (`surface --member X --types`).
    pub fn surfaceTypes(self: *Session, alloc: Allocator, filter: []const u8) ![]surface_mod.MemberDump {
        return surface_mod.dumpMemberTypes(self, alloc, filter);
    }

    pub fn invoke(self: *Session, method: []const u8, args: []const json.Value) !invoke_mod.CallResult {
        return invoke_mod.invoke(self, method, args);
    }

    /// Invoke with options (e.g. enumerate_ret: VT_DISPATCH return ->
    /// JSON array via the VB6 Collection contract).
    pub fn invokeEx(self: *Session, method: []const u8, args: []const json.Value, opts: invoke_mod.InvokeOpts) !invoke_mod.CallResult {
        return invoke_mod.invokeEx(self, method, args, opts);
    }

    pub fn queryToJson(self: *Session, sql: []const u8) !json.Value {
        return @import("recordset.zig").queryToJson(self, sql);
    }

    pub fn queryToJsonFrom(self: *Session, sql: []const u8, method: []const u8) !json.Value {
        return @import("recordset.zig").queryToJsonFrom(self, sql, method);
    }
};
