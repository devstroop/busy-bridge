//! JSON args -> VARIANT slot fill, rgvarg reversal and typed-box
//! read-back (split from invoke.zig — size gate): the slot arrays and
//! loops the invokeEx call site drives around IDispatch::Invoke.
//! Public surface (invoke/invokeEx/CallResult + marker re-exports)
//! stays re-exported from invoke.zig.
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
const VariantClear = win32.VariantClear;
const SysStringLen = win32.SysStringLen;
const SysFreeString = win32.SysFreeString;
const DISP_E_PARAMNOTFOUND = win32.DISP_E_PARAMNOTFOUND;
const VT_DATE = win32.VT_DATE;
const VT_BSTR = win32.VT_BSTR;
const VT_BOOL = win32.VT_BOOL;
const VT_R8 = win32.VT_R8;
const VT_CY = win32.VT_CY;
const VT_I4 = win32.VT_I4;
const VT_I8 = win32.VT_I8;
const VT_ERROR = win32.VT_ERROR;
const VT_VARIANT = win32.VT_VARIANT;
const VT_BYREF = win32.VT_BYREF;
const VT_DISPATCH = win32.VT_DISPATCH;
const fromUtf16 = utf16.fromUtf16;
const ByrefKind = markers.ByrefKind;
const byrefKindFromMarker = markers.byrefKindFromMarker;

/// Per-invoke argument slot arrays (split from invoke.zig): allocated
/// once per invokeEx call, filled from the JSON args (marker-aware),
/// reversed into rgvarg order, read back after IDispatch::Invoke, then
/// freed via `deinit`.
pub const Slots = struct {
    storage: []VARIANT = &.{},
    byref_slots: []VARIANT = &.{},
    is_byref: []bool = &.{},
    byref_kind: []ByrefKind = &.{},
    // typed out-param boxes (preallocated; read back after Invoke)
    f8box: []f64 = &.{},
    i4box: []i32 = &.{},
    i8box: []i64 = &.{},
    bstrbox: []?[*:0]u16 = &.{},
    boolbox: []i16 = &.{},
    dispbox: []?*win32.IDispatch = &.{},
    // heap slots for $collection input args (typed VT_BYREF|VT_DISPATCH
    // boxes; each holds an owned dispatch ref, freed via freeInbox).
    inboxes: []?*?*win32.IDispatch = &.{},
    // heap boxes for $record input args (VT_RECORD UDT payloads).
    recboxes: []?*marshal.RecBox = &.{},
    /// fill watermark for error-path cleanup (a partially filled
    /// prefix is VariantClear'd / freed exactly once, in order).
    filled: usize = 0,

    /// Allocate + initialize every array for `n` args (OOM-safe: the
    /// errdefer frees whatever was allocated before the failure).
    pub fn init(alloc: Allocator, n: usize) !Slots {
        var s: Slots = .{};
        errdefer s.deinit(alloc);
        s.storage = try alloc.alloc(VARIANT, n);
        s.byref_slots = try alloc.alloc(VARIANT, n);
        s.is_byref = try alloc.alloc(bool, n);
        s.byref_kind = try alloc.alloc(ByrefKind, n);
        s.f8box = try alloc.alloc(f64, n);
        s.i4box = try alloc.alloc(i32, n);
        s.i8box = try alloc.alloc(i64, n);
        s.bstrbox = try alloc.alloc(?[*:0]u16, n);
        s.boolbox = try alloc.alloc(i16, n);
        s.dispbox = try alloc.alloc(?*win32.IDispatch, n);
        s.inboxes = try alloc.alloc(?*?*win32.IDispatch, n);
        s.recboxes = try alloc.alloc(?*marshal.RecBox, n);
        for (0..n) |i| {
            s.storage[i] = VARIANT.init();
            s.byref_slots[i] = VARIANT.init();
            s.is_byref[i] = false;
            s.byref_kind[i] = .variant;
            s.f8box[i] = 0;
            s.i4box[i] = 0;
            s.i8box[i] = 0;
            s.bstrbox[i] = null;
            s.boolbox[i] = 0;
            s.dispbox[i] = null;
            s.inboxes[i] = null;
            s.recboxes[i] = null;
        }
        return s;
    }

    /// Free the slot arrays (invokeEx `defer`). On success every
    /// VARIANT/box content has already been released by `readBack`.
    pub fn deinit(self: *Slots, alloc: Allocator) void {
        alloc.free(self.storage);
        alloc.free(self.byref_slots);
        alloc.free(self.is_byref);
        alloc.free(self.byref_kind);
        alloc.free(self.f8box);
        alloc.free(self.i4box);
        alloc.free(self.i8box);
        alloc.free(self.bstrbox);
        alloc.free(self.boolbox);
        alloc.free(self.dispbox);
        alloc.free(self.inboxes);
        alloc.free(self.recboxes);
    }

    /// Release + free a $collection input slot (owned dispatch ref).
    fn freeInbox(sess: *Session, slot: *?*?*win32.IDispatch) void {
        if (slot.*) |s| {
            if (s.*) |d| _ = d.vtbl.Release(d);
            sess.alloc.destroy(s);
            slot.* = null;
        }
    }

    /// Release + free a $record input box (VT_RECORD payload).
    fn freeRecBox(sess: *Session, slot: *?*marshal.RecBox) void {
        if (slot.*) |rb| {
            rb.destroy(sess.alloc);
            sess.alloc.destroy(rb);
            slot.* = null;
        }
    }

    /// VariantClear except VT_RECORD variants (those free via RecBox —
    /// VariantClear would call RecordClear through trap-thunked vtable).
    fn clearStorageVar(v: *VARIANT) void {
        if (v.vt == win32.VT_RECORD or v.vt == (win32.VT_BYREF | win32.VT_RECORD)) return;
        _ = VariantClear(v);
    }

    /// invokeEx errdefer body: free everything `fill` produced so far
    /// (VT contents first; the arrays go with `deinit`).
    pub fn freeFilled(self: *Slots, sess: *Session) void {
        for (0..self.filled) |i| {
            if (!self.is_byref[i]) clearStorageVar(&self.storage[i]) else _ = VariantClear(&self.byref_slots[i]);
            freeInbox(sess, &self.inboxes[i]);
            freeRecBox(sess, &self.recboxes[i]);
        }
    }

    /// After a failed Invoke: the callee may have written into typed
    /// boxes before failing — release anything they hold. (Error
    /// strings surface from invoke.zig; this only frees.)
    pub fn releaseCalleeWrites(self: *Slots, sess: *Session) void {
        for (0..self.storage.len) |i| {
            if (self.bstrbox[i]) |bp| {
                SysFreeString(bp);
                self.bstrbox[i] = null;
            }
            if (self.dispbox[i]) |p| {
                _ = p.vtbl.Release(p);
                self.dispbox[i] = null;
            }
            freeInbox(sess, &self.inboxes[i]);
            freeRecBox(sess, &self.recboxes[i]);
        }
    }

    /// Fill every slot from the JSON args in logical order; the
    /// caller's `errdefer freeFilled` releases partial state on error.
    pub fn fill(self: *Slots, sess: *Session, args: []const json.Value) !void {
        const n = self.storage.len;
        for (0..n) |i| {
            if (i < args.len) {
                const a = args[i];
                if (a == .obj) {
                    if (a.get("$date")) |dv| {
                        // VT_DATE input — report methods date-type their params
                        const ole: f64 = switch (dv.*) {
                            .str => |s| helpers.dateToOle(s) orelse {
                                sess.setErr("invalid $date '{s}' (YYYY-MM-DD / DD-MM-YYYY)", .{s});
                                return error.BadArgs;
                            },
                            .int => |iv| @floatFromInt(iv),
                            .float => |f| f,
                            else => return error.BadArgs,
                        };
                        self.storage[i].vt = VT_DATE;
                        self.storage[i].data.dblVal = ole;
                        self.filled += 1;
                        continue;
                    }
                    var handled = false;
                    try marshal.fillInputMarker(sess, self.storage, self.inboxes, self.recboxes, &self.filled, i, &a, &handled);
                    if (handled) continue;
                    if (a.get("$byref")) |inner| {
                        // Typed box marker (services-class typed params) or
                        // empty/absent marker -> Variant-byref seeded by value.
                        const kind: ByrefKind = if (inner.* == .str)
                            byrefKindFromMarker(inner.str) orelse {
                                sess.setErr("unknown $byref marker '{s}' (use \"\", f8, i4, cy, i8, bstr, bool, dispatch)", .{inner.str});
                                return error.BadArgs;
                            }
                        else
                            .variant;
                        switch (kind) {
                            .variant => {
                                try marshal.variantFromValue(sess, inner, &self.byref_slots[i]);
                                self.storage[i].vt = VT_BYREF | VT_VARIANT;
                                self.storage[i].data.byref = &self.byref_slots[i];
                            },
                            .f8 => {
                                self.storage[i].vt = VT_BYREF | VT_R8;
                                self.storage[i].data.byref = &self.f8box[i];
                                self.byref_kind[i] = .f8;
                            },
                            .i4 => {
                                self.storage[i].vt = VT_BYREF | VT_I4;
                                self.storage[i].data.byref = &self.i4box[i];
                                self.byref_kind[i] = .i4;
                            },
                            .cy => {
                                self.storage[i].vt = VT_BYREF | VT_CY;
                                self.storage[i].data.byref = &self.i8box[i];
                                self.byref_kind[i] = .cy;
                            },
                            .i8 => {
                                self.storage[i].vt = VT_BYREF | VT_I8;
                                self.storage[i].data.byref = &self.i8box[i];
                                self.byref_kind[i] = .i8;
                            },
                            .bstr => {
                                self.storage[i].vt = VT_BYREF | VT_BSTR;
                                self.storage[i].data.byref = @ptrCast(&self.bstrbox[i]);
                                self.byref_kind[i] = .bstr;
                            },
                            .bool => {
                                self.storage[i].vt = VT_BYREF | VT_BOOL;
                                self.storage[i].data.byref = &self.boolbox[i];
                                self.byref_kind[i] = .bool;
                            },
                            .dispatch, .collection => {
                                self.storage[i].vt = VT_BYREF | VT_DISPATCH;
                                self.storage[i].data.byref = @ptrCast(&self.dispbox[i]);
                                self.byref_kind[i] = kind;
                            },
                        }
                        self.is_byref[i] = true;
                        self.filled += 1;
                        continue;
                    }
                }
                try marshal.variantFromValue(sess, &a, &self.storage[i]);
                self.filled += 1;
            } else {
                // omitted optional parameter
                self.storage[i].vt = VT_ERROR;
                self.storage[i].data.scode = DISP_E_PARAMNOTFOUND;
                self.filled += 1;
            }
        }
    }

    /// rgvarg is reversed — build the reversed copy invokeEx passes as
    /// DISPPARAMS.rgvarg (caller frees).
    pub fn reversed(self: *const Slots, alloc: Allocator) ![]VARIANT {
        const nn = self.storage.len;
        var rev = try alloc.alloc(VARIANT, nn);
        for (0..nn) |i| {
            rev[i] = self.storage[nn - 1 - i];
        }
        return rev;
    }

    /// Post-invoke read-back: typed/Variant out-params -> JSON `outs`
    /// (owned slice; the CallResult owner frees it). Also frees every
    /// input payload the callee consumed.
    pub fn readBack(self: *Slots, sess: *Session) ![]json.Value {
        var outs: std.ArrayList(json.Value) = .empty;
        errdefer {
            for (outs.items) |*o| o.deinit(sess.alloc);
            outs.deinit(sess.alloc);
        }
        for (0..self.storage.len) |i| {
            if (self.inboxes[i] != null or self.recboxes[i] != null) {
                // $collection/$record input: free the owned payload (the
                // byref-dispatch clear is a no-op; VT_RECORD frees via
                // RecBox — see clearStorageVar).
                clearStorageVar(&self.storage[i]);
                freeInbox(sess, &self.inboxes[i]);
                freeRecBox(sess, &self.recboxes[i]);
            } else if (self.is_byref[i]) {
                const v = switch (self.byref_kind[i]) {
                    .variant => blk: {
                        const vv = try marshal.valueFromVariant(sess, &self.byref_slots[i]);
                        _ = VariantClear(&self.byref_slots[i]);
                        break :blk vv;
                    },
                    .f8 => json.Value{ .float = self.f8box[i] },
                    .i4 => json.Value{ .int = self.i4box[i] },
                    .cy => json.Value{ .float = @as(f64, @floatFromInt(self.i8box[i])) / 10000.0 }, // VT_CY scale
                    .i8 => json.Value{ .int = self.i8box[i] },
                    .bstr => blk: {
                        const bp = self.bstrbox[i] orelse break :blk json.Value{ .str = "" };
                        const len = SysStringLen(bp);
                        const s = try fromUtf16(sess.alloc, bp, len);
                        SysFreeString(bp);
                        self.bstrbox[i] = null;
                        break :blk json.Value{ .str = s };
                    },
                    .bool => json.Value{ .bool = self.boolbox[i] != 0 },
                    .dispatch => blk: {
                        // Ownership: the callee AddRef'd into our box; we
                        // Release exactly once. Contents need collection
                        // enumeration (future work) - surface the handle.
                        const p = self.dispbox[i] orelse break :blk json.Value{ .str = "" };
                        _ = p.vtbl.Release(p);
                        self.dispbox[i] = null;
                        break :blk json.Value{ .str = try sess.alloc.dupe(u8, "<dispatch>") };
                    },
                    .collection => blk: {
                        // VB6 Collection contract (Count + 1-based Item):
                        // enumerate into a JSON array, then Release exactly
                        // once. Enumeration failure fails CLOSED (empty
                        // array) - the call itself succeeded.
                        const p = self.dispbox[i] orelse break :blk json.Value{ .arr = &.{} };
                        defer {
                            _ = p.vtbl.Release(p);
                            self.dispbox[i] = null;
                        }
                        break :blk collection.toJson(sess, sess.alloc, p) catch json.Value{ .arr = &.{} };
                    },
                };
                try outs.append(sess.alloc, v);
            } else clearStorageVar(&self.storage[i]);
        }
        return outs.toOwnedSlice(sess.alloc);
    }
};
