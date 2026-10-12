//! COM invocation: IDispatch::Invoke + result/out-param values back to
//! JSON. JSON args -> VARIANT slot fill/reversal/read-back split to
//! invoke_args.zig (size gate); $byref marker parsing in markers.zig.
const std = @import("std");
const json = @import("../../util/json.zig");
const Session = @import("session.zig").Session;
const win32 = @import("win32.zig");
const collection = @import("collection.zig");
const marshal = @import("marshal.zig");
const markers = @import("markers.zig");
const invoke_args = @import("invoke_args.zig");

const VARIANT = win32.VARIANT;
const DISPPARAMS = win32.DISPPARAMS;
const IID_NULL = win32.IID_NULL;
const VariantClear = win32.VariantClear;
const DISP_E_EXCEPTION = win32.DISP_E_EXCEPTION;
const VT_DISPATCH = win32.VT_DISPATCH;

pub const CallResult = @import("result.zig").CallResult;

// Marker parsing split to markers.zig (size gate); re-exported so
// existing call sites keep their imports.
pub const ByrefKind = markers.ByrefKind;
pub const byrefKindFromMarker = markers.byrefKindFromMarker;

/// Invoke options (collection read-back): `enumerate_ret` walks a
/// VT_DISPATCH return value through the VB6 Collection contract
/// (core/com/collection.zig — nested recursed) instead of "<dispatch>";
/// `retain_ret` keeps an EXTRA reference to a VT_DISPATCH return in
/// CallResult.ret_disp (caller Releases; used by $collection input
/// marshaling via BUSY's own GetCollectionObj).
pub const InvokeOpts = struct {
    enumerate_ret: bool = false,
    retain_ret: bool = false,
    /// DISPATCH_PROPERTYPUT (4) / PUTREF (8) instead of METHOD (1) —
    /// for property-set calls (e.g. CSR_CashBook.DayBook put).
    flags: u32 = 1,
};

pub fn invoke(self: *Session, method: []const u8, args: []const json.Value) !CallResult {
    return self.invokeEx(method, args, .{});
}

/// Invoke method by name. JSON args are mapped to Variant params.
/// Markers (issue #7 M3 — services-class params are TYPED, not Variant):
///   {"$byref": ""}         -> VT_BYREF|VT_VARIANT (As Variant params)
///   {"$byref": "f8"|"i4"|"cy"|"i8"} -> typed out-param boxes (As
///                              Double/Long/Currency/LongLong)
///   {"$byref": "bstr"|"bool"|"dispatch"} -> typed out-param boxes (As
///                              String/Boolean/Object — VB6-style typed
///                              ByRef; iteration-5 report §4: unblocks
///                              ValidUserNamePasswrdForParty & friends)
///   {"$date": "YYYY-MM-DD"} -> VT_DATE input (report date params)
/// Typed/Variant post-call values are returned in `outs`. Typed box
/// read-back: bstr -> string ("" when the callee wrote none; the BSTR
/// is freed), bool -> boolean, dispatch -> "<dispatch>" (released) or "".
pub fn invokeEx(self: *Session, method: []const u8, args: []const json.Value, opts: InvokeOpts) !CallResult {
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

    // Box arrays + fill/reversal/read-back split to invoke_args.zig
    // (size gate): the errdefer below releases slot CONTENTS on error,
    // deinit frees the arrays.
    var slots = try invoke_args.Slots.init(self.alloc, n);
    defer slots.deinit(self.alloc);
    errdefer slots.freeFilled(self);
    try slots.fill(self, args);

    // rgvarg is reversed
    var reversed = try slots.reversed(self.alloc);
    defer self.alloc.free(reversed);

    var dp = DISPPARAMS{
        .rgvarg = if (n > 0) &reversed[0] else null,
        .rgdispidNamedArgs = null,
        .cArgs = @intCast(n),
        .cNamedArgs = 0,
    };
    var result = VARIANT.init();
    hr = d.vtbl.Invoke(d, dispid, &IID_NULL, 0, @intCast(opts.flags), &dp, &result, null, null);
    if (hr < 0) {
        _ = VariantClear(&result);
        // The callee may have written into typed boxes before failing -
        // release anything they hold, then surface the error.
        slots.releaseCalleeWrites(self);
        if (hr == DISP_E_EXCEPTION) self.loadErrorInfo() else self.setErr("Invoke('{s}') failed 0x{x}", .{ method, @as(u32, @bitCast(hr)) });
        return error.InvokeFailed;
    }

    var ret: json.Value = undefined;
    var ret_disp: ?*anyopaque = null;
    if (opts.enumerate_ret and result.vt == VT_DISPATCH) {
        // Collection-as-return (GetUserList / GetVchTypesForUserRights
        // shape): enumerate via the VB6 Collection contract; the
        // VariantClear below Releases the dispatch exactly once.
        // Enumeration failure fails CLOSED ([]), the call succeeded.
        if (result.data.pdispVal) |pv| {
            const rd: *win32.IDispatch = @ptrCast(@alignCast(pv));
            ret = collection.toJson(self, self.alloc, rd) catch json.Value{ .arr = &.{} };
        } else {
            ret = json.Value{ .arr = &.{} };
        }
    } else {
        ret = try valueFromVariant(self, &result);
    }
    if (opts.retain_ret and result.vt == VT_DISPATCH) {
        // Extra reference for the caller (inputCollection chaining);
        // the VariantClear below still releases the ORIGINAL ref.
        if (result.data.pdispVal) |pv| {
            const rd: *win32.IDispatch = @ptrCast(@alignCast(pv));
            _ = rd.vtbl.AddRef(rd);
            ret_disp = rd;
        }
    }
    _ = VariantClear(&result);

    return .{ .ret = ret, .outs = try slots.readBack(self), .ret_disp = ret_disp };
}

// VARIANT<->JSON marshaling moved to marshal.zig (size-gate split);
// re-exported here so existing call sites keep their imports.
pub const variantFromValue = marshal.variantFromValue;
pub const valueFromVariant = marshal.valueFromVariant;

// ---------------- tests (pure) ----------------

const testing = std.testing;

// Pure $byref marker tests live in markers.zig (split).
