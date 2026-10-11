//! VB6 Collection read marshaling (BUSY-004/012/013 unblock): turn a
//! returned `VT_DISPATCH` that follows the VB6 Collection contract
//! (`Count` property + 1-based `Item(index)` property) into a JSON
//! array. Probe-verified shape (iteration 7): `GetUserList` /
//! `GetVchTypesForUserRights` return `<dispatch>` Collections whose
//! contents were unreachable — this walks them via direct
//! `IDispatch::GetIDsOfNames` + `Invoke(DISPATCH_PROPERTYGET)`, no
//! IEnumVARIANT QI required.
//!
//! Nested collections (iteration 21): `GetCompList` items are
//! *themselves* VB6 Collections — a 10-field row per company
//! (`DEMO`, `COMP0001`, FY start, …). `Item()` results that are
//! VT_DISPATCH are therefore recursed up to `max_depth` levels
//! (fail-soft: a dispatch that does not satisfy the Collection
//! contract, or sits past the depth cap, still surfaces as the
//! `"<dispatch>"` string).
//!
//! Ownership: the caller owns `disp` (this module never Releases —
//! the invoke read-back path does, exactly once). Elements convert
//! through the same VARIANT->JSON mapping as return values; nested
//! non-collection dispatches surface as `"<dispatch>"` (M1).
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
const VT_DISPATCH = win32.VT_DISPATCH;

/// Sanity cap — a corrupt Count must not turn into an allocation bomb.
pub const max_items: i32 = 100_000;

/// Recursion cap for nested Collections (GetCompList = 2 levels;
/// 3 leaves headroom without risking cycles).
pub const max_depth: u32 = 3;

const DISPATCH_PROPERTYGET: u32 = 0x2;

/// Explicit error set: the recursion itemAt <-> toJsonDepth would
/// otherwise be a mutual inferred-set dependency (compile error).
/// NameTooLong/NonAsciiName come from session.toWideFixed via
/// dispInvoke; NoSpaceLeft from oleDateToText via valueFromVariant.
pub const WalkError = error{ BadCollection, InvokeFailed, NameTooLong, NonAsciiName, NoSuchMember, NoSpaceLeft, OutOfMemory };

/// Enumerate `disp` (VB6 Collection contract) into a JSON array.
pub fn toJson(sess: *Session, alloc: Allocator, disp: *win32.IDispatch) !json.Value {
    return toJsonDepth(sess, alloc, disp, 0);
}

fn toJsonDepth(sess: *Session, alloc: Allocator, disp: *win32.IDispatch, depth: u32) WalkError!json.Value {
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
        try arr.append(alloc, try itemAt(sess, alloc, disp, i, depth));
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

/// Single Item(index) property-get. A VT_DISPATCH result that looks
/// like a Collection (Count reads as I4) recurses — `res` still owns
/// the reference during the walk, and the deferred VariantClear
/// releases it exactly once afterwards. Anything else converts via
/// the session's standard VARIANT->JSON mapping (nested
/// non-collection dispatch -> "<dispatch>").
fn itemAt(sess: *Session, alloc: Allocator, disp: *win32.IDispatch, index: i32, depth: u32) WalkError!json.Value {
    var arg = VARIANT.init();
    arg.vt = win32.VT_I4;
    arg.data.lVal = index;
    var res = try propertyGet(sess, disp, "Item", &arg);
    defer _ = VariantClear(&res);
    if (res.vt == VT_DISPATCH and depth + 1 < max_depth) {
        if (res.data.pdispVal) |pv| {
            const rd: *win32.IDispatch = @ptrCast(@alignCast(pv));
            if (toJsonDepth(sess, alloc, rd, depth + 1)) |v| {
                return v;
            } else |_| {
                // Not a Collection (or broken): fall back to the M1
                // string; drop the error so one odd item cannot fail
                // the surrounding enumeration.
                sess.clearErr();
            }
        }
    }
    return invoke_mod.valueFromVariant(sess, &res);
}

const invoke_mod = @import("invoke.zig");

/// Generic dispatch member invoke (property-get or method) with 0/1
/// VARIANT args — shared by the Collection walk and input marshaling.
pub fn dispInvoke(
    sess: *Session,
    disp: *win32.IDispatch,
    name: []const u8,
    flags: u32,
    args: []const VARIANT,
) !VARIANT {
    var wname: [256]u16 = undefined;
    _ = try sess.toWideFixed(name, &wname);
    var names: [1][*:0]const u16 = .{@ptrCast(&wname)};
    var dispid: i32 = 0;
    var hr = disp.vtbl.GetIDsOfNames(disp, &IID_NULL, &names, 1, 0, &dispid);
    if (hr < 0) {
        sess.setErr("collection member '{s}' unknown (0x{x})", .{ name, @as(u32, @bitCast(hr)) });
        return error.NoSuchMember;
    }
    var dp = DISPPARAMS{
        .rgvarg = if (args.len > 0) @ptrCast(@constCast(args.ptr)) else null,
        .rgdispidNamedArgs = null,
        .cArgs = @intCast(args.len),
        .cNamedArgs = 0,
    };
    var res = VARIANT.init();
    hr = disp.vtbl.Invoke(disp, dispid, &IID_NULL, flags, 1, &dp, &res, null, null);
    if (hr < 0) {
        _ = VariantClear(&res);
        sess.setErr("collection {s} invoke failed 0x{x}", .{ name, @as(u32, @bitCast(hr)) });
        return error.InvokeFailed;
    }
    return res;
}

/// Generic zero/one-arg property-get on an arbitrary dispatch.
fn propertyGet(sess: *Session, disp: *win32.IDispatch, name: []const u8, arg: ?*VARIANT) !VARIANT {
    var one = [_]VARIANT{if (arg) |a| a.* else VARIANT.init()};
    const args: []const VARIANT = if (arg != null) one[0..1] else &.{};
    return dispInvoke(sess, disp, name, DISPATCH_PROPERTYGET, args);
}
