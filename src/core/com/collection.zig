//! VB6 Collection read marshaling (BUSY-004/012/013 unblock): turn a
//! returned `VT_DISPATCH` that follows the VB6 Collection contract
//! (`Count` property + 1-based `Item(index)` property) into a JSON
//! array. Probe-verified shape (iteration 7): `GetUserList` /
//! `GetVchTypesForUserRights` return `<dispatch>` Collections whose
//! contents were unreachable — this walks them via direct
//! `IDispatch::GetIDsOfNames` + `Invoke(DISPATCH_PROPERTYGET)`, no
//! IEnumVARIANT QI required.
//!
//! Ownership: the caller owns `disp` (this module never Releases —
//! the invoke read-back path does, exactly once). Elements convert
//! through the same VARIANT->JSON mapping as return values; nested
//! dispatches surface as `"<dispatch>"` (M1).
const std = @import("std");
const json = @import("../../util/json.zig");
const Session = @import("session.zig").Session;
const win32 = @import("win32.zig");
const utf16 = @import("utf16.zig");

const Allocator = std.mem.Allocator;
const VARIANT = win32.VARIANT;
const DISPPARAMS = win32.DISPPARAMS;
const IID_NULL = win32.IID_NULL;
const VariantClear = win32.VariantClear;
const VT_I4 = win32.VT_I4;
const VT_INT = win32.VT_INT;

/// Sanity cap — a corrupt Count must not turn into an allocation bomb.
pub const max_items: i32 = 100_000;

const DISPATCH_PROPERTYGET: u32 = 0x2;

/// Enumerate `disp` (VB6 Collection contract) into a JSON array.
pub fn toJson(sess: *Session, alloc: Allocator, disp: *win32.IDispatch) !json.Value {
    const count = try propI32(sess, disp, "Count");
    if (count < 0 or count > max_items) {
        sess.setErr("collection Count {d} outside 0..{d}", .{ count, max_items });
        return error.BadCollection;
    }
    var arr: std.ArrayList(json.Value) = .empty;
    errdefer {
        for (arr.items) |*v| v.deinit(alloc);
        arr.deinit(alloc);
    }
    // VB6 Collection Item() is 1-based.
    var i: i32 = 1;
    while (i <= count) : (i += 1) {
        try arr.append(alloc, try itemAt(sess, disp, i));
    }
    return .{ .arr = try arr.toOwnedSlice(alloc) };
}

/// Single property-get returning an I4 (Count).
fn propI32(sess: *Session, disp: *win32.IDispatch, name: []const u8) !i32 {
    var res = try propertyGet(sess, disp, name, null);
    defer _ = VariantClear(&res);
    return switch (res.vt) {
        VT_I4 => res.data.lVal,
        VT_INT => res.data.intVal,
        else => {
            sess.setErr("collection {s} returned vt=0x{x}, expected I4", .{ name, res.vt });
            return error.BadCollection;
        },
    };
}

/// Single Item(index) property-get; value converts via the session's
/// standard VARIANT->JSON mapping (nested dispatch -> "<dispatch>").
fn itemAt(sess: *Session, disp: *win32.IDispatch, index: i32) !json.Value {
    var arg = VARIANT.init();
    arg.vt = win32.VT_I4;
    arg.data.lVal = index;
    var res = try propertyGet(sess, disp, "Item", &arg);
    defer _ = VariantClear(&res);
    return invoke_mod.valueFromVariant(sess, &res);
}

const invoke_mod = @import("invoke.zig");

/// Generic zero/one-arg property-get on an arbitrary dispatch.
fn propertyGet(sess: *Session, disp: *win32.IDispatch, name: []const u8, arg: ?*VARIANT) !VARIANT {
    var wname: [256]u16 = undefined;
    _ = try sess.toWideFixed(name, &wname);
    var names: [1][*:0]const u16 = .{@ptrCast(&wname)};
    var dispid: i32 = 0;
    var hr = disp.vtbl.GetIDsOfNames(disp, &IID_NULL, &names, 1, 0, &dispid);
    if (hr < 0) {
        sess.setErr("collection member '{s}' unknown (0x{x})", .{ name, @as(u32, @bitCast(hr)) });
        return error.NoSuchMember;
    }
    var one = [_]VARIANT{if (arg) |a| a.* else VARIANT.init()};
    var dp = DISPPARAMS{
        .rgvarg = if (arg != null) &one[0] else null,
        .rgdispidNamedArgs = null,
        .cArgs = if (arg != null) 1 else 0,
        .cNamedArgs = 0,
    };
    var res = VARIANT.init();
    hr = disp.vtbl.Invoke(disp, dispid, &IID_NULL, DISPATCH_PROPERTYGET, 1, &dp, &res, null, null);
    if (hr < 0) {
        _ = VariantClear(&res);
        sess.setErr("collection {s} property-get failed 0x{x}", .{ name, @as(u32, @bitCast(hr)) });
        return error.InvokeFailed;
    }
    return res;
}
