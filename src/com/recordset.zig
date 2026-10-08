//! Recordset traversal: run SQL via GetRecordset, stream rows out as JSON.
const std = @import("std");
const json = @import("../json.zig");
const Session = @import("session.zig").Session;
const win32 = @import("win32.zig");
const invoke = @import("invoke.zig");

const Allocator = std.mem.Allocator;
const VARIANT = win32.VARIANT;
const DISPPARAMS = win32.DISPPARAMS;
const GUID = win32.GUID;
const IID_NULL = win32.IID_NULL;
const IDispatch = win32.IDispatch;
const VariantClear = win32.VariantClear;
const DISP_E_EXCEPTION = win32.DISP_E_EXCEPTION;
const VT_DISPATCH = win32.VT_DISPATCH;
const VT_UNKNOWN = win32.VT_UNKNOWN;
const VT_BOOL = win32.VT_BOOL;
const VT_EMPTY = win32.VT_EMPTY;
const variantFromValue = invoke.variantFromValue;
const valueFromVariant = invoke.valueFromVariant;

pub fn queryToJson(self: *Session, sql: []const u8) !json.Value {
    const d = self.disp orelse return error.NoDispatch;
    var sql_v = VARIANT.init();
    try variantFromValue(self, &.{ .str = sql }, &sql_v);
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

    return recordsetToJson(self, rso);
}

pub fn recordsetToJson(self: *Session, rs: *IDispatch) !json.Value {
    const alloc = self.alloc;
    // Fields
    const fields = (try getDisp(self, rs, "Fields", 2, &.{})) orelse return error.NoFields;
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
                const v = try valueFromVariant(self, &result);
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
        const f = (try itemDispatch(self, fields, ci)) orelse {
            col_names[@intCast(ci)] = try alloc.dupe(u8, "");
            continue;
        };
        defer _ = f.vtbl.Release(f);
        col_names[@intCast(ci)] = try propStr(self, f, "Name");
    }

    // rows
    var rows: std.ArrayList(json.Value) = .empty;
    errdefer {
        for (rows.items) |*r| r.deinit(alloc);
        rows.deinit(alloc);
    }

    // MoveFirst (ignore failure = empty set)
    _ = callVoid(self, rs, "MoveFirst");
    var guard: usize = 0;
    while (guard < 10_000_000) : (guard += 1) {
        if (try propBool(self, rs, "EOF")) break;
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
            const f = (try itemDispatch(self, fields, i)) orelse continue;
            defer _ = f.vtbl.Release(f);
            const val = try propVariant(self, f, "Value");
            row[@intCast(i)].val.deinit(alloc);
            row[@intCast(i)].val = val;
        }
        try rows.append(alloc, .{ .obj = row });
        filled = 0; // ownership moved into `rows`
        _ = callVoid(self, rs, "MoveNext");
    }
    return .{ .arr = try rows.toOwnedSlice(alloc) };
}

fn itemDispatch(self: *Session, fields: *IDispatch, idx: i64) !?*IDispatch {
    var idxv = VARIANT.init();
    try variantFromValue(self, &.{ .int = idx }, &idxv);
    defer _ = VariantClear(&idxv);
    return getDisp(self, fields, "Item", 2, &.{idxv});
}

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
    const v = (try getVariant(self, obj, name)) orelse return .null;
    var vv = v;
    defer _ = VariantClear(&vv);
    return valueFromVariant(self, &vv);
}

fn propStr(self: *Session, obj: *IDispatch, name: []const u8) ![]const u8 {
    const v = (try getVariant(self, obj, name)) orelse return try self.alloc.dupe(u8, "");
    var vv = v;
    defer _ = VariantClear(&vv);
    const s = try valueFromVariant(self, &vv);
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
    const v = (try getVariant(self, obj, name)) orelse return true; // missing EOF -> stop
    var vv = v;
    defer _ = VariantClear(&vv);
    if (vv.vt == VT_BOOL) return vv.data.boolVal != 0;
    if (vv.vt == VT_EMPTY) return true;
    const j = try valueFromVariant(self, &vv);
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
