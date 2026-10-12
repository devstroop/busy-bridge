//! VARIANT <-> JSON marshaling (split from invoke.zig — size gate):
//! the single mapping both directions for COM arguments, results, and
//! out-params. Re-exported via invoke.zig for existing call sites.
const std = @import("std");
const Allocator = std.mem.Allocator;
const json = @import("../../util/json.zig");
const helpers = @import("../../util/helpers.zig");
const Session = @import("session.zig").Session;
const win32 = @import("win32.zig");
const utf16 = @import("utf16.zig");

const VARIANT = win32.VARIANT;
const VariantClear = win32.VariantClear;
const SysAllocString = win32.SysAllocString;
const SysStringLen = win32.SysStringLen;
const toUtf16 = utf16.toUtf16;
const fromUtf16 = utf16.fromUtf16;
const VT_NULL = win32.VT_NULL;
const VT_I4 = win32.VT_I4;
const VT_I8 = win32.VT_I8;
const VT_R8 = win32.VT_R8;
const VT_DATE = win32.VT_DATE;
const VT_BSTR = win32.VT_BSTR;
const VT_BOOL = win32.VT_BOOL;
const VT_ERROR = win32.VT_ERROR;
const VT_VARIANT = win32.VT_VARIANT;
const VT_EMPTY = win32.VT_EMPTY;
const VT_I2 = win32.VT_I2;
const VT_R4 = win32.VT_R4;
const VT_INT = win32.VT_INT;
const VT_UI4 = win32.VT_UI4;
const VT_UINT = win32.VT_UINT;
const VT_HRESULT = win32.VT_HRESULT;
const VT_DISPATCH = win32.VT_DISPATCH;
const VT_UNKNOWN = win32.VT_UNKNOWN;
const VT_BYREF = win32.VT_BYREF;
const CoCreateInstance = win32.CoCreateInstance;
const CLSIDFromProgID = win32.CLSIDFromProgID;
const CLSCTX_INPROC_SERVER = win32.CLSCTX_INPROC_SERVER;
const collection_mod = @import("collection.zig");
const collitem = @import("collitem.zig");
const registry = @import("../registry.zig");

const DISPATCH_METHOD: u32 = 0x1;

/// A record arg's owned payload (the hand-built UDT buffer; freed
/// after the invoke — BSTR fields inside are released post-invoke via `owned` (§22).
/// `box` is the byrefvar-shape inner VARIANT (owned; freed too — it
/// leaked 16 B/record on the error path until iteration 19).
/// `next` chains further record boxes (T3: `$collection` items that
/// are `"$record"` UDT rows) — every box in the run frees exactly
/// once via [freeRecChain].
pub const RecBox = struct {
    buf: [*]u8,
    size: u32,
    box: ?*win32.VARIANT = null,
    /// COM-embedded fields (BSTR / Collection) released before buf.
    owned: []const @import("recordinfo.zig").OwnedField = &.{},
    next: ?*RecBox = null,
    pub fn destroy(self: *RecBox, alloc: Allocator) void {
        @import("recordinfo.zig").releaseOwned(self.buf, self.owned);
        if (self.owned.len > 0) alloc.free(self.owned);
        if (self.box) |b| alloc.destroy(b);
        alloc.free(self.buf[0..self.size]);
    }
};

/// Free a chain of RecBoxes (T3: `$collection` record items), head
/// included — each payload released exactly once, then the node.
pub fn freeRecChain(alloc: Allocator, head: ?*RecBox) void {
    var cur = head;
    while (cur) |rb| {
        const nx = rb.next;
        rb.destroy(alloc);
        alloc.destroy(rb);
        cur = nx;
    }
}

/// Splice the `more` chain (possibly null) onto the END of `head`
/// (T3: merging per-field record-item chains into RecordInst.coll_recs;
/// head stays stable, empty head absorbs `more`).
pub fn chainAppend(head: *?*RecBox, more: ?*RecBox) void {
    const extra = more orelse return;
    const cur = head.* orelse {
        head.* = extra;
        return;
    };
    var tail = cur;
    while (tail.next) |n| tail = n;
    tail.next = extra;
}

/// Input-arg markers handled in the invoke loop (split for the size
/// gate): `{"$i2": n}` (VB6 Short), `{"$collection": [...]}` (typed
/// ByRef _Collection box), `{"$record": {type,fields}}` (VT_RECORD
/// UDT instance via IRecordInfo). Sets `handled` when consumed.
pub fn fillInputMarker(
    sess: *Session,
    storage: []VARIANT,
    inboxes: []?*?*win32.IDispatch,
    recboxes: []?*RecBox,
    filled: *usize,
    i: usize,
    a: *const json.Value,
    handled: *bool,
) !void {
    handled.* = false;
    if (a.* != .obj) return;
    if (a.get("$i2")) |iv| {
        // VT_I2 input (VB6 Short params — e.g. GetRepOptValues p_RepID;
        // VT_I4 mismatches DISP_E_TYPEMISMATCH live).
        storage[i] = VARIANT.init();
        storage[i].vt = win32.VT_I2;
        storage[i].data.lVal = @intCast(if (iv.* == .int) iv.int else 0);
        filled.* += 1;
        handled.* = true;
        return;
    }
    if (a.get("$record")) |rd| {
        // VT_RECORD UDT instance (udtRepOptions etc.): {"$record":
        // {"htype":<hreftype from surface --types>,"fields":{...}}}
        if (rd.* != .obj) {
            sess.setErr("$record must be an object with htype+fields", .{});
            return error.BadArgs;
        }
        const ht = rd.get("htype") orelse return error.BadArgs;
        const flds = rd.get("fields") orelse return error.BadArgs;
        if (ht.* != .int) return error.BadArgs;
        const inst = try @import("recordinfo.zig").recordFromHreftype(sess, sess.alloc, @intCast(ht.int), flds);
        const rec = inst.variant;
        // Extract the payload buffer for cleanup; the byrefvar shape
        // wraps the record in an owned inner VARIANT (freed via RecBox).
        var recbox: ?*win32.VARIANT = null;
        const buf: [*]u8 = if (rec.vt == (win32.VT_BYREF | win32.VT_VARIANT)) blk: {
            recbox = @ptrCast(@alignCast(rec.data.byref.?));
            break :blk @ptrCast(recbox.?.data.rec.pRecValue.?);
        } else @ptrCast(rec.data.rec.pRecValue.?);
        const rbsize: u32 = rec.r2;
        const rb = sess.alloc.create(RecBox) catch |e| {
            @import("recordinfo.zig").releaseOwned(buf, inst.owned);
            if (inst.owned.len > 0) sess.alloc.free(inst.owned);
            freeRecChain(sess.alloc, inst.coll_recs);
            return e;
        };
        rb.* = .{ .buf = buf, .size = rbsize, .box = recbox, .owned = inst.owned, .next = inst.coll_recs };
        recboxes[i] = rb;
        filled.* += 1;
        storage[i] = rec;
        handled.* = true;
        return;
    }
    if (a.get("$collection")) |items| {
        // VB6 Collection INPUT argument (BUSY-004): BUSY's own
        // GetCollectionObj builds the Collection, items are Added, and
        // it is passed as a typed VT_BYREF|VT_DISPATCH box — the shape
        // a `ByRef p_ICol As _Collection` typelib param takes
        // (typelib-verified: VT_PTR -> VT_USERDEFINED; byref-VARIANT
        // got DISP_E_TYPEMISMATCH live).
        if (items.* != .arr) {
            sess.setErr("$collection must be a JSON array of items", .{});
            return error.BadArgs;
        }
        const slot = try sess.alloc.create(?*win32.IDispatch);
        slot.* = null;
        inboxes[i] = slot;
        filled.* += 1; // errdefer frees the slot on failure
        // T3: record items inside the collection chain their RecBoxes
        // onto THIS arg's recbox slot (freed after the invoke).
        const cv = try inputCollection(sess, items.arr, &recboxes[i]);
        slot.* = @ptrCast(@alignCast(cv.data.pdispVal)); // ref transfers
        storage[i] = VARIANT.init();
        storage[i].vt = VT_BYREF | VT_DISPATCH;
        storage[i].data.byref = @ptrCast(slot);
        handled.* = true;
    }
}

/// VB6 Collection as an INPUT argument (BUSY-004 day-book/ledger
/// family): `{"$collection": [...]}` asks BUSY for its OWN Collection
/// via `GetCollectionObj` — which lives on CFixedInterface only, so it
/// runs on a transient default-class aux (live-probed: calling it on
/// the COtherServices1 session yields no_such_member; company state is
/// process-global, the aux needs no OpenDB) — `Add`s each JSON item
/// in order, and returns a VT_DISPATCH VARIANT the caller owns
/// (VariantClear of the boxed arg releases it after the target call).
/// Items marshal through [collitem.classify]: scalars via
/// [variantFromValue], `"$record"` rows via the record build (T3).
/// `recs` receives the RecBox chain of record items — the CALLER owns
/// it in every outcome (success keeps it for the post-invoke free;
/// the invoke errdefers / recordinfo errdefer free it on failure).
pub fn inputCollection(sess: *Session, items: []const json.Value, recs: *?*RecBox) anyerror!VARIANT {
    var aux = try Session.init(sess.alloc);
    defer aux.deinit();
    const fi = registry.newestFixedInterface() orelse {
        sess.setErr("no registered Busy2L*.CFixedInterface (is BUSY installed?)", .{});
        return error.NoBusyProgId;
    };
    aux.create(fi) catch |aerr| {
        sess.setErr("aux create '{s}' failed: {s}", .{ fi, @errorName(aerr) });
        return aerr;
    };
    var empty: [0]json.Value = .{};
    var res = try aux.invokeEx("GetCollectionObj", &empty, .{ .retain_ret = true });
    defer res.deinit(aux.alloc);
    const disp: *win32.IDispatch = @ptrCast(@alignCast(res.ret_disp orelse {
        sess.setErr("GetCollectionObj returned no dispatch (ret vt-shape mismatch)", .{});
        return error.BadCollection;
    }));
    // The retained ref transfers into `out` immediately; VariantClear
    // of the boxed arg (invoke.zig) releases it after the target call.
    var out = VARIANT.init();
    out.vt = VT_DISPATCH;
    out.data.pdispVal = disp;
    errdefer _ = VariantClear(&out);

    for (items) |*item| {
        var arg = VARIANT.init();
        var key_v = VARIANT.init();
        var has_key = false;
        // T3: record items are added as byval VT_RECORD and are NEVER
        // VariantClear'd (RecordClear would call through the
        // trap-thunked IRecordInfo vtable) — their buffers ride the
        // RecBox chain until after the target invoke.
        var is_record = false;
        defer {
            if (!is_record) _ = VariantClear(&arg);
        }
        defer _ = VariantClear(&key_v);
        switch (collitem.classify(item)) {
            // Keyed pair form: ["value", "KEY"] or [{"$date":…}|
            // {"$record":…}, "KEY"] -> Col.Add value, key (RepOpt-style
            // named options: START_DATE/END_DATE/ACC_NAME…;
            // positional-only collections were live-proven to yield
            // {}).
            .keyed_scalar, .keyed_date, .keyed_record => {
                if (collitem.classify(&item.arr[0]) == .record) {
                    try collitem.recordItemVariant(sess, &item.arr[0], recs, &arg, &is_record);
                } else try scalarItemValue(sess, &item.arr[0], &arg);
                try variantFromValue(sess, &item.arr[1], &key_v);
                has_key = true;
            },
            // VT_RECORD UDT row (T3) — Collection of records.
            .record => try collitem.recordItemVariant(sess, item, recs, &arg, &is_record),
            // Nested {"$date": ...} marker -> VT_DATE items (day-book
            // date positions may demand typed dates, not strings).
            .date, .scalar => try scalarItemValue(sess, item, &arg),
        }
        // rgvarg is reversed: pass [key, value] so Add sees (value, key).
        const two: [2]VARIANT = .{ key_v, arg };
        var added = collection_mod.dispInvoke(sess, disp, "Add", DISPATCH_METHOD, if (has_key) two[0..] else two[1..]) catch |err| {
            sess.setErr("Collection.Add failed: {s}", .{@errorName(err)});
            return err;
        };
        _ = VariantClear(&added);
    }
    return out;
}

/// Scalar/Date collection-item value (keyed value slot + positional
/// form): {"$date": …} -> VT_DATE, everything else via
/// [variantFromValue] (unchanged iteration-8/20 semantics).
fn scalarItemValue(sess: *Session, v: *const json.Value, arg: *VARIANT) !void {
    if (v.* == .obj) {
        if (v.get("$date")) |dv| {
            const ole: f64 = switch (dv.*) {
                .str => |s| helpers.dateToOle(s) orelse return error.BadArgs,
                .int => |iv| @floatFromInt(iv),
                .float => |f| f,
                else => return error.BadArgs,
            };
            arg.vt = win32.VT_DATE;
            arg.data.dblVal = ole;
            return;
        }
    }
    try variantFromValue(sess, v, arg);
}

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
            return valueFromVariant(self, inner);
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
        // OLE date (Tran1.Date etc.) — was silently .null before M1;
        // BUSY's display format is DD/MM/YYYY.
        VT_DATE => {
            var b: [16]u8 = undefined;
            return .{ .str = try self.alloc.dupe(u8, try helpers.oleDateToText(&b, vv.data.dblVal)) };
        },
        VT_BOOL => return .{ .bool = vv.data.boolVal != 0 },
        VT_BSTR => {
            const b = vv.data.bstrVal orelse return .null;
            const len = SysStringLen(b);
            const s = fromUtf16(self.alloc, b, len) catch return error.OutOfMemory;
            return .{ .str = s };
        },
        VT_DISPATCH, VT_UNKNOWN => {
            // owned copy: every .str must be allocator-owned (freeing a
            // static literal corrupts the heap — found via
            // GetAllVchSeriesCodes returning a dispatch collection)
            return .{ .str = try self.alloc.dupe(u8, "<dispatch>") };
        },
        VT_ERROR => return .null,
        else => return .null,
    }
}
