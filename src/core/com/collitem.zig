//! `$collection` ITEM classification + record-item build (T3): a
//! collection item is either a scalar (the iteration-8/20 paths —
//! plain values, `{"$date":…}` and the keyed `["value","KEY"]` pair)
//! or a `{"$record":{htype,fields}}` UDT row. Record rows unlock
//! Collections of records — `SaveVchSeriesGrpConfigForMultiple-
//! SeriesCreation` (2 Variant params, CFixedInterface1) and richer
//! day-book input items — which `$collection` previously could not
//! express (scalar-only `variantFromValue` -> `.obj` =
//! `UnsupportedArgType`).
//!
//! Safety design (re-derived after a lost attempt at this task):
//!
//! - Items are classified in the pure [classify] helper below; record
//!   items NEVER fall through to `variantFromValue`.
//! - A record item builds via the proven `recordFromHreftype` path
//!   and is unwrapped to a **byval VT_RECORD** item — the shape
//!   `Collection.Add` receives.
//! - The item VARIANT is never VariantClear'd (RecordClear would call
//!   through the trap-thunked IRecordInfo vtable). Its buffer rides a
//!   `RecBox` chained through `next` onto the enclosing arg's recbox
//!   slot (`fillInputMarker`) or the parent record's
//!   `RecordInst.coll_recs` (nested `$collection`-in-`$record`
//!   items) — freed exactly once, after the target invoke.
const std = @import("std");
const json = @import("../../util/json.zig");
const Session = @import("session.zig").Session;
const win32 = @import("win32.zig");
const marshal = @import("marshal.zig");
const recordinfo = @import("recordinfo.zig");

const Allocator = std.mem.Allocator;
const VARIANT = win32.VARIANT;
const RecBox = marshal.RecBox;

/// How one `$collection` item marshals.
pub const ItemKind = enum {
    scalar, // plain value -> variantFromValue
    date, // {"$date": ...} -> VT_DATE
    record, // {"$record": {htype,fields}} -> VT_RECORD UDT row (T3)
    keyed_scalar, // ["value", "KEY"] pair
    keyed_date, // [{"$date": ...}, "KEY"]
    keyed_record, // [{"$record": ...}, "KEY"] (T3)
};

/// Pure item classifier — the T3 safety hinge: record markers must
/// route to the record build (no `unsupported_arg_type`), everything
/// else keeps the exact scalar/keyed/date routing live-proven in
/// iterations 8 and 20. A malformed `{"$record": <non-obj>}` still
/// classifies as a record so the build path surfaces the precise
/// BadArgs instead of the generic unsupported type.
pub fn classify(item: *const json.Value) ItemKind {
    if (item.* == .arr and item.arr.len == 2 and item.arr[1] == .str) {
        const v = &item.arr[0];
        if (v.* == .str) return .keyed_scalar;
        if (v.* == .obj) {
            if (v.get("$date")) |_| return .keyed_date;
            if (v.get("$record")) |_| return .keyed_record;
        }
    }
    if (item.* == .obj) {
        if (item.get("$date")) |_| return .date;
        if (item.get("$record")) |_| return .record;
    }
    return .scalar;
}

/// Build one `{"$record":{htype,fields}}` collection item into `arg`
/// as an unwrapped byval VT_RECORD, chaining its RecBox (payload +
/// embedded COM-owned fields + nested record items) onto `recs`.
/// `arg` must NOT be VariantClear'd afterwards — the caller's
/// deferred clear is skipped via `*is_record` (ownership passes to
/// the chain, freed after the target invoke).
pub fn recordItemVariant(
    sess: *Session,
    v: *const json.Value,
    recs: *?*RecBox,
    arg: *VARIANT,
    is_record: *bool,
) !void {
    const rd = v.get("$record") orelse return error.BadArgs;
    if (rd.* != .obj) {
        sess.setErr("$record must be an object with htype+fields", .{});
        return error.BadArgs;
    }
    const ht = rd.get("htype") orelse return error.BadArgs;
    const flds = rd.get("fields") orelse return error.BadArgs;
    if (ht.* != .int) return error.BadArgs;
    const inst = try recordinfo.recordFromHreftype(sess, sess.alloc, @intCast(ht.int), flds);
    // Extract the payload buffer (same as the $record arg path); the
    // item itself unwraps to the byval VT_RECORD Collection.Add gets.
    const rec = inst.variant;
    var recbox: ?*win32.VARIANT = null;
    var item_var = rec;
    const buf: [*]u8 = if (rec.vt == (win32.VT_BYREF | win32.VT_VARIANT)) blk: {
        recbox = @ptrCast(@alignCast(rec.data.byref.?));
        item_var = recbox.?.*; // byrefvar: inner box already holds the byval VT_RECORD
        break :blk @ptrCast(recbox.?.data.rec.pRecValue.?);
    } else blk: {
        if (rec.vt == (win32.VT_BYREF | win32.VT_RECORD)) item_var.vt = win32.VT_RECORD; // byrefrec: strip BYREF, same pointers
        break :blk @ptrCast(rec.data.rec.pRecValue.?);
    };
    const rbsize: u32 = rec.r2;
    const rb = sess.alloc.create(RecBox) catch |e| {
        recordinfo.releaseOwned(buf, inst.owned);
        if (inst.owned.len > 0) sess.alloc.free(inst.owned);
        if (recbox) |b| sess.alloc.destroy(b);
        marshal.freeRecChain(sess.alloc, inst.coll_recs);
        return e;
    };
    // One run: this item's box, then record items inside ITS embedded
    // $collection fields, then whatever the caller already chained.
    rb.* = .{ .buf = buf, .size = rbsize, .box = recbox, .owned = inst.owned, .next = null };
    var run: ?*RecBox = rb;
    marshal.chainAppend(&run, inst.coll_recs);
    marshal.chainAppend(&run, recs.*);
    recs.* = run;
    arg.* = item_var;
    is_record.* = true;
}

/// Splice the `more` chain (possibly null) onto the front of `head`.
pub const chainAppend = marshal.chainAppend;

// ---------------- tests (pure) ----------------

const testing = std.testing;

/// Parse a wire-shaped fixture with the real JSON parser (the item
/// markers reach the classifier exactly as CLI `call` args do).
fn parse(text: []const u8) !json.Value {
    return json.parse(testing.allocator, text);
}

const rec_json =
    \\{"$record":{"htype":50333725,"fields":{"VchSerGrpName":"ZZ T3"}}}
;

test "t3 classify: $record items route to the record path" {
    // Shape of the T3 acceptance case: a udtVchSeriesGrpConfig row
    // (htype 50333725, §20); the fields are never parsed by classify.
    var rec = try parse(rec_json);
    defer rec.deinit(testing.allocator);
    try testing.expectEqual(ItemKind.record, classify(&rec));
    var keyed = try parse("[{\"$record\":{\"htype\":50333725,\"fields\":{}}},\"GRPKEY\"]");
    defer keyed.deinit(testing.allocator);
    try testing.expectEqual(ItemKind.keyed_record, classify(&keyed));
}

test "t3 classify: a collection of UDT rows never hits the scalar wall" {
    // The T3 acceptance shape: {"$collection":[{"$record":…},
    // {"$record":…}]} — every item must classify .record, i.e. build
    // via recordFromHreftype, never variantFromValue (whose .obj arm
    // is error.UnsupportedArgType).
    const rows_json = "[{\"$record\":{\"htype\":50333725,\"fields\":{\"tmpVchSerGrpCode\":9001}}}," ++
        "{\"$record\":{\"htype\":50333725,\"fields\":{\"tmpVchSerGrpCode\":9002}}}]";
    var coll = try parse(rows_json);
    defer coll.deinit(testing.allocator);
    for (coll.arr) |*it| try testing.expectEqual(ItemKind.record, classify(it));
}

test "t3 classify: scalar collection paths unchanged" {
    var items = try parse("[1290,\"ZigVch9\",true,{\"$date\":\"2026-04-05\"}," ++
        "[\"v\",\"K\"],[{\"$date\":\"2026-04-05\"},\"K\"],[1,\"x\"],[{\"foo\":1},\"K\"]]");
    defer items.deinit(testing.allocator);
    try testing.expectEqual(ItemKind.scalar, classify(&items.arr[0]));
    try testing.expectEqual(ItemKind.scalar, classify(&items.arr[1]));
    try testing.expectEqual(ItemKind.scalar, classify(&items.arr[2]));
    try testing.expectEqual(ItemKind.date, classify(&items.arr[3]));
    try testing.expectEqual(ItemKind.keyed_scalar, classify(&items.arr[4]));
    try testing.expectEqual(ItemKind.keyed_date, classify(&items.arr[5]));
    // Non-keyed arrays and unknown objects keep the old fall-through:
    // variantFromValue(.arr/.obj) -> UnsupportedArgType (unchanged).
    try testing.expectEqual(ItemKind.scalar, classify(&items.arr[6]));
    try testing.expectEqual(ItemKind.scalar, classify(&items.arr[7]));
}

test "t3 chainAppend splices record-item chains (link-only, no free)" {
    // Stack nodes: link structure only — payloads are not freed here.
    var b1: [4]u8 = undefined;
    var b2: [4]u8 = undefined;
    var b3: [4]u8 = undefined;
    var head: ?*RecBox = null;
    var a = RecBox{ .buf = &b1, .size = 4 };
    chainAppend(&head, &a);
    var chain2_head = RecBox{ .buf = &b2, .size = 4 };
    var chain2_tail = RecBox{ .buf = &b3, .size = 4 };
    chain2_head.next = &chain2_tail;
    chainAppend(&head, &chain2_head);
    try testing.expect(head == &a);
    try testing.expect(a.next == &chain2_head);
    try testing.expect(chain2_head.next == &chain2_tail);
    try testing.expect(chain2_tail.next == null);
    chainAppend(&head, null); // null is a no-op
    try testing.expect(head == &a);
}
