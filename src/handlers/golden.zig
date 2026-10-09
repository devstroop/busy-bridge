//! Golden-read flow script (issue #9): the read-only ERP flows recorded
//! into JSONL transcripts by `busy-bridge record`. Lives in the handlers
//! layer (moved from core/com/record.zig with the ops -> handlers
//! relocation): the Recorder is core mechanics; *which* flows to
//! exercise is facade orchestration, so core never imports handlers.
const std = @import("std");
const json = @import("../util/json.zig");
const Session = @import("../core/com/session.zig").Session;
const Recorder = @import("../core/com/record.zig").Recorder;
const masters = @import("masters.zig");
const vouchers = @import("vouchers.zig");
const reports = @import("reports.zig");

const Allocator = std.mem.Allocator;

/// Read-only golden flows: company open, master/voucher lists, one
/// balance + stock report, one raw query, two forced error paths.
/// Every step records ok-or-error and continues - the transcript is
/// faithful whatever DEMO contains; fixed dates keep diffs reviewable.
pub fn runGoldenReads(sess: *Session, alloc: Allocator, rec: *Recorder, busy: []const u8, data: []const u8, comp: []const u8) !void {
    var open_args = [_]json.Value{ .{ .str = busy }, .{ .str = data }, .{ .str = comp } };
    var opened = rec.recordInvoke("OpenDB", &open_args) catch |err| return err;
    defer opened.deinit(alloc);
    if (opened != .bool or !opened.bool) {
        sess.setErr("record: OpenDB reported false for '{s}'", .{comp});
        return error.OpenDbFailed;
    }
    if (masters.list(sess, alloc, .account, .{ .limit = 5 })) |r| {
        var v = r;
        v.deinit(alloc);
    } else |_| {}
    if (masters.list(sess, alloc, .item, .{ .limit = 5 })) |r| {
        var v = r;
        v.deinit(alloc);
    } else |_| {}
    if (masters.get(sess, alloc, .account, "Cash")) |r| {
        var v = r;
        v.deinit(alloc);
    } else |_| {}
    if (vouchers.list(sess, alloc, .{ .limit = 5 })) |r| {
        var v = r;
        v.deinit(alloc);
    } else |_| {}
    if (reports.trialBalance(sess, alloc, "2025-04-01", "2026-03-31")) |r| {
        var v = r;
        v.deinit(alloc);
    } else |_| {}
    if (reports.stockStatus(sess, alloc, "2026-03-31", 5, null, null)) |r| {
        var v = r;
        v.deinit(alloc);
    } else |_| {}
    // NOTE: facade reads above exercise Session internally but bypass
    // the recorder (they call sess.invoke directly). The transcript-grade
    // captures are the raw calls below; wiring Recorder through ops is
    // the documented follow-up (comptime session interface, see 009).
    if (rec.recordQuery("SELECT TOP 2 Code, Name FROM Master1")) |r| {
        var v = r;
        v.deinit(alloc);
    } else |_| {}
    var bogus = [_]json.Value{};
    if (rec.recordInvoke("NoSuchMethod_Bogus", &bogus)) |r| {
        var v = r;
        v.deinit(alloc);
    } else |_| {}
    if (rec.recordQuery("SELECT * FROM NoSuchTable_Xyz")) |r| {
        var v = r;
        v.deinit(alloc);
    } else |_| {}
}
