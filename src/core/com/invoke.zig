//! COM invocation: JSON args -> VARIANT marshaling, IDispatch::Invoke,
//! result/out-param values back to JSON.
const std = @import("std");
const json = @import("../../util/json.zig");
const helpers = @import("../../util/helpers.zig");
const Session = @import("session.zig").Session;
const win32 = @import("win32.zig");
const utf16 = @import("utf16.zig");
const collection = @import("collection.zig");
const marshal = @import("marshal.zig");
const markers = @import("markers.zig");

const Allocator = std.mem.Allocator;
const VARIANT = win32.VARIANT;
const DISPPARAMS = win32.DISPPARAMS;
const IID_NULL = win32.IID_NULL;
const VariantClear = win32.VariantClear;
const SysAllocString = win32.SysAllocString;
const SysFreeString = win32.SysFreeString;
const SysStringLen = win32.SysStringLen;
const DISP_E_PARAMNOTFOUND = win32.DISP_E_PARAMNOTFOUND;
const DISP_E_EXCEPTION = win32.DISP_E_EXCEPTION;
const VT_EMPTY = win32.VT_EMPTY;
const VT_NULL = win32.VT_NULL;
const VT_I2 = win32.VT_I2;
const VT_I4 = win32.VT_I4;
const VT_R4 = win32.VT_R4;
const VT_R8 = win32.VT_R8;
const VT_CY = win32.VT_CY;
const VT_DATE = win32.VT_DATE;
const VT_BSTR = win32.VT_BSTR;
const VT_DISPATCH = win32.VT_DISPATCH;
const VT_ERROR = win32.VT_ERROR;
const VT_BOOL = win32.VT_BOOL;
const VT_VARIANT = win32.VT_VARIANT;
const VT_UNKNOWN = win32.VT_UNKNOWN;
const VT_UI4 = win32.VT_UI4;
const VT_I8 = win32.VT_I8;
const VT_INT = win32.VT_INT;
const VT_UINT = win32.VT_UINT;
const VT_HRESULT = win32.VT_HRESULT;
const VT_BYREF = win32.VT_BYREF;
const toUtf16 = utf16.toUtf16;
const fromUtf16 = utf16.fromUtf16;

pub const CallResult = @import("result.zig").CallResult;

// Marker parsing split to markers.zig (size gate); re-exported so
// existing call sites keep their imports.
pub const ByrefKind = markers.ByrefKind;
pub const byrefKindFromMarker = markers.byrefKindFromMarker;

/// Invoke options (collection read-back): `enumerate_ret` walks a
/// VT_DISPATCH return value through the VB6 Collection contract
/// (core/com/collection.zig) instead of surfacing "<dispatch>";
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

    var storage = try self.alloc.alloc(VARIANT, @intCast(n));
    defer self.alloc.free(storage);
    var byref_slots = try self.alloc.alloc(VARIANT, @intCast(n));
    defer self.alloc.free(byref_slots);
    var is_byref = try self.alloc.alloc(bool, @intCast(n));
    defer self.alloc.free(is_byref);
    var byref_kind = try self.alloc.alloc(ByrefKind, @intCast(n));
    defer self.alloc.free(byref_kind);
    // typed out-param boxes (preallocated; read back after Invoke)
    var f8box = try self.alloc.alloc(f64, @intCast(n));
    defer self.alloc.free(f8box);
    var i4box = try self.alloc.alloc(i32, @intCast(n));
    defer self.alloc.free(i4box);
    var i8box = try self.alloc.alloc(i64, @intCast(n));
    defer self.alloc.free(i8box);
    var bstrbox = try self.alloc.alloc(?[*:0]u16, @intCast(n));
    defer self.alloc.free(bstrbox);
    var boolbox = try self.alloc.alloc(i16, @intCast(n));
    defer self.alloc.free(boolbox);
    var dispbox = try self.alloc.alloc(?*win32.IDispatch, @intCast(n));
    defer self.alloc.free(dispbox);
    // heap slots for $collection input args (typed VT_BYREF|VT_DISPATCH
    // boxes; each holds an owned dispatch ref, freed via freeInboxes).
    var inboxes = try self.alloc.alloc(?*?*win32.IDispatch, @intCast(n));
    defer self.alloc.free(inboxes);
    // heap boxes for $record input args (VT_RECORD UDT payloads).
    var recboxes = try self.alloc.alloc(?*marshal.RecBox, @intCast(n));
    defer self.alloc.free(recboxes);
    for (0..@as(usize, @intCast(n))) |i| {
        storage[i] = VARIANT.init();
        byref_slots[i] = VARIANT.init();
        is_byref[i] = false;
        byref_kind[i] = .variant;
        f8box[i] = 0;
        i4box[i] = 0;
        i8box[i] = 0;
        bstrbox[i] = null;
        boolbox[i] = 0;
        dispbox[i] = null;
        inboxes[i] = null;
        recboxes[i] = null;
    }

    // Fill in logical order; free on error.
    var filled: usize = 0;
    errdefer for (0..filled) |i| {
        if (!is_byref[i]) clearStorageVar(&storage[i]) else _ = VariantClear(&byref_slots[i]);
        freeInbox(self, &inboxes[i]);
        freeRecBox(self, &recboxes[i]);
    };

    for (0..@as(usize, @intCast(n))) |i| {
        if (i < args.len) {
            const a = args[i];
            if (a == .obj) {
                if (a.get("$date")) |dv| {
                    // VT_DATE input — report methods date-type their params
                    const ole: f64 = switch (dv.*) {
                        .str => |s| helpers.dateToOle(s) orelse {
                            self.setErr("invalid $date '{s}' (YYYY-MM-DD / DD-MM-YYYY)", .{s});
                            return error.BadArgs;
                        },
                        .int => |iv| @floatFromInt(iv),
                        .float => |f| f,
                        else => return error.BadArgs,
                    };
                    storage[i].vt = VT_DATE;
                    storage[i].data.dblVal = ole;
                    filled += 1;
                    continue;
                }
                var handled = false;
                try marshal.fillInputMarker(self, storage, inboxes, recboxes, &filled, i, &a, &handled);
                if (handled) continue;
                if (a.get("$byref")) |inner| {
                    // Typed box marker (services-class typed params) or
                    // empty/absent marker -> Variant-byref seeded by value.
                    const kind: ByrefKind = if (inner.* == .str)
                        byrefKindFromMarker(inner.str) orelse {
                            self.setErr("unknown $byref marker '{s}' (use \"\", f8, i4, cy, i8, bstr, bool, dispatch)", .{inner.str});
                            return error.BadArgs;
                        }
                    else
                        .variant;
                    switch (kind) {
                        .variant => {
                            try variantFromValue(self, inner, &byref_slots[i]);
                            storage[i].vt = VT_BYREF | VT_VARIANT;
                            storage[i].data.byref = &byref_slots[i];
                        },
                        .f8 => {
                            storage[i].vt = VT_BYREF | VT_R8;
                            storage[i].data.byref = &f8box[i];
                            byref_kind[i] = .f8;
                        },
                        .i4 => {
                            storage[i].vt = VT_BYREF | VT_I4;
                            storage[i].data.byref = &i4box[i];
                            byref_kind[i] = .i4;
                        },
                        .cy => {
                            storage[i].vt = VT_BYREF | VT_CY;
                            storage[i].data.byref = &i8box[i];
                            byref_kind[i] = .cy;
                        },
                        .i8 => {
                            storage[i].vt = VT_BYREF | VT_I8;
                            storage[i].data.byref = &i8box[i];
                            byref_kind[i] = .i8;
                        },
                        .bstr => {
                            storage[i].vt = VT_BYREF | VT_BSTR;
                            storage[i].data.byref = @ptrCast(&bstrbox[i]);
                            byref_kind[i] = .bstr;
                        },
                        .bool => {
                            storage[i].vt = VT_BYREF | VT_BOOL;
                            storage[i].data.byref = &boolbox[i];
                            byref_kind[i] = .bool;
                        },
                        .dispatch, .collection => {
                            storage[i].vt = VT_BYREF | VT_DISPATCH;
                            storage[i].data.byref = @ptrCast(&dispbox[i]);
                            byref_kind[i] = kind;
                        },
                    }
                    is_byref[i] = true;
                    filled += 1;
                    continue;
                }
            }
            try variantFromValue(self, &a, &storage[i]);
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
    hr = d.vtbl.Invoke(d, dispid, &IID_NULL, 0, @intCast(opts.flags), &dp, &result, null, null);
    if (hr < 0) {
        _ = VariantClear(&result);
        // The callee may have written into typed boxes before failing -
        // release anything they hold, then surface the error.
        for (0..@as(usize, @intCast(n))) |i| {
            if (bstrbox[i]) |bp| {
                SysFreeString(bp);
                bstrbox[i] = null;
            }
            if (dispbox[i]) |p| {
                _ = p.vtbl.Release(p);
                dispbox[i] = null;
            }
            freeInbox(self, &inboxes[i]);
            freeRecBox(self, &recboxes[i]);
        }
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

    var outs: std.ArrayList(json.Value) = .empty;
    errdefer {
        for (outs.items) |*o| o.deinit(self.alloc);
        outs.deinit(self.alloc);
    }
    for (0..@as(usize, @intCast(n))) |i| {
        if (inboxes[i] != null or recboxes[i] != null) {
            // $collection/$record input: free the owned payload (the
            // byref-dispatch clear is a no-op; VT_RECORD frees via
            // RecBox — see clearStorageVar).
            clearStorageVar(&storage[i]);
            freeInbox(self, &inboxes[i]);
            freeRecBox(self, &recboxes[i]);
        } else if (is_byref[i]) {
            const v = switch (byref_kind[i]) {
                .variant => blk: {
                    const vv = try valueFromVariant(self, &byref_slots[i]);
                    _ = VariantClear(&byref_slots[i]);
                    break :blk vv;
                },
                .f8 => json.Value{ .float = f8box[i] },
                .i4 => json.Value{ .int = i4box[i] },
                .cy => json.Value{ .float = @as(f64, @floatFromInt(i8box[i])) / 10000.0 }, // VT_CY scale
                .i8 => json.Value{ .int = i8box[i] },
                .bstr => blk: {
                    const bp = bstrbox[i] orelse break :blk json.Value{ .str = "" };
                    const len = SysStringLen(bp);
                    const s = try fromUtf16(self.alloc, bp, len);
                    SysFreeString(bp);
                    bstrbox[i] = null;
                    break :blk json.Value{ .str = s };
                },
                .bool => json.Value{ .bool = boolbox[i] != 0 },
                .dispatch => blk: {
                    // Ownership: the callee AddRef'd into our box; we
                    // Release exactly once. Contents need collection
                    // enumeration (future work) - surface the handle.
                    const p = dispbox[i] orelse break :blk json.Value{ .str = "" };
                    _ = p.vtbl.Release(p);
                    dispbox[i] = null;
                    break :blk json.Value{ .str = try self.alloc.dupe(u8, "<dispatch>") };
                },
                .collection => blk: {
                    // VB6 Collection contract (Count + 1-based Item):
                    // enumerate into a JSON array, then Release exactly
                    // once. Enumeration failure fails CLOSED (empty
                    // array) - the call itself succeeded.
                    const p = dispbox[i] orelse break :blk json.Value{ .arr = &.{} };
                    defer {
                        _ = p.vtbl.Release(p);
                        dispbox[i] = null;
                    }
                    break :blk collection.toJson(self, self.alloc, p) catch json.Value{ .arr = &.{} };
                },
            };
            try outs.append(self.alloc, v);
        } else clearStorageVar(&storage[i]);
    }
    return .{ .ret = ret, .outs = try outs.toOwnedSlice(self.alloc), .ret_disp = ret_disp };
}

// VARIANT<->JSON marshaling moved to marshal.zig (size-gate split);
// re-exported here so existing call sites keep their imports.
pub const variantFromValue = marshal.variantFromValue;
pub const valueFromVariant = marshal.valueFromVariant;

/// Release + free a $collection input slot (owned dispatch ref).
fn freeInbox(self: *Session, slot: *?*?*win32.IDispatch) void {
    if (slot.*) |s| {
        if (s.*) |d| _ = d.vtbl.Release(d);
        self.alloc.destroy(s);
        slot.* = null;
    }
}

/// Release + free a $record input box (VT_RECORD payload).
fn freeRecBox(self: *Session, slot: *?*marshal.RecBox) void {
    if (slot.*) |rb| {
        rb.destroy(self.alloc);
        self.alloc.destroy(rb);
        slot.* = null;
    }
}

/// VariantClear except VT_RECORD variants (those free via RecBox —
/// VariantClear would call RecordClear through trap-thunked vtable).
fn clearStorageVar(v: *VARIANT) void {
    if (v.vt == win32.VT_RECORD or v.vt == (win32.VT_BYREF | win32.VT_RECORD)) return;
    _ = VariantClear(v);
}

// ---------------- tests (pure) ----------------

const testing = std.testing;

// Pure $byref marker tests live in markers.zig (split).
