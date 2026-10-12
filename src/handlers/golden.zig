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
const ops = @import("../handlers.zig");

const Allocator = std.mem.Allocator;

/// Read-only golden flows: company open, master/voucher lists, one
/// balance + stock report, one raw query, two forced error paths.
/// Every step records ok-or-error and continues - the transcript is
/// faithful whatever DEMO contains; fixed dates keep diffs reviewable.
/// Issue #9 additions: enumerated collection returns (company + FY
/// pickers), the masters keyset page pair (exact SQL via the shared
/// builder), and the series-grp UDT initializer on a second session
/// (COtherServices owns it - not the ...1 variant, report section 14).
pub fn runGoldenReads(sess: *Session, alloc: Allocator, rec: *Recorder, busy: []const u8, data: []const u8, comp: []const u8) !void {
    var open_args = [_]json.Value{ .{ .str = busy }, .{ .str = data }, .{ .str = comp } };
    var opened = rec.recordInvoke("OpenDB", &open_args) catch |err| return err;
    defer opened.deinit(alloc);
    if (opened != .bool or !opened.bool) {
        sess.setErr("record: OpenDB reported false for '{s}'", .{comp});
        return error.OpenDbFailed;
    }
    // Issue #9: enumerated Collection return - the company picker
    // (nested Collection of 10-field rows). The FY picker lives on
    // CFixedInterface1 and is recorded with the aux sessions below.
    var comp_list_args = [_]json.Value{.{ .str = data }};
    if (rec.recordInvokeEx("GetCompList", &comp_list_args, .{ .enumerate_ret = true })) |r| {
        var v = r;
        v.deinit(alloc);
    } else |_| {}
    // Issue #9: masters list with keyset cursor - facade exercise (page
    // 1, then the next_cursor page; unrecorded like the other facade
    // reads) followed by the transcript-grade raw page pair below.
    if (masters.list(sess, alloc, .account, .{ .limit = 2 })) |r| {
        var v = r;
        defer v.deinit(alloc);
        if (v.get("page")) |pg| {
            if (pg.* == .obj) {
                if (pg.get("next_cursor")) |nc| {
                    if (nc.* == .str) {
                        if (masters.list(sess, alloc, .account, .{ .limit = 2, .cursor = nc.str })) |r2| {
                            var v2 = r2;
                            v2.deinit(alloc);
                        } else |_| {}
                    }
                }
            }
        }
    } else |_| {}
    const page1_sql = try masters.listSql(alloc, masters.typeCode(.account), "TOP 3 ", "", "");
    defer alloc.free(page1_sql);
    if (rec.recordQuery(page1_sql)) |r| {
        var rows = r;
        defer rows.deinit(alloc);
        // page 2 resumes strictly after page 1's last Name - the same
        // clause list() renders for an opaque cursor page.
        if (rows == .arr and rows.arr.len > 0) {
            const last = &rows.arr[rows.arr.len - 1];
            if (last.* == .obj) {
                if (last.get("Name")) |nv| {
                    if (nv.* == .str) {
                        const ks = try masters.keysetClause(alloc, nv.str);
                        defer alloc.free(ks);
                        const sql2 = try masters.listSql(alloc, masters.typeCode(.account), "TOP 3 ", ks, "");
                        defer alloc.free(sql2);
                        if (rec.recordQuery(sql2)) |r2| {
                            var v2 = r2;
                            v2.deinit(alloc);
                        } else |_| {}
                    }
                }
            }
        }
    } else |_| {}
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
    // Issue #9 aux shapes: methods that live on OTHER classes than the
    // default FixedInterface. Each gets a transient session opened via
    // openCompany (handlers.zig: the class's own OpenDB when it has one,
    // else a fixed-interface aux - company state is process-global and
    // outlives the opener). Open steps are facade-style (unrecorded,
    // like the other facade reads); the shape-bearing calls below are
    // transcript-grade.
    {
        var fy_sess = try Session.init(alloc);
        defer fy_sess.deinit();
        try fy_sess.create("Busy2L21.CFixedInterface1");
        try ops.openCompany(&fy_sess, .{ .prog_id = "Busy2L21.CFixedInterface1", .busy = busy, .data = data, .comp = comp });
        rec.sess = &fy_sess;
        defer rec.sess = sess;
        var fy_args = [_]json.Value{.{ .str = comp }};
        if (rec.recordInvokeEx("GetAllFinYearsOfSpecificCompCode", &fy_args, .{ .enumerate_ret = true })) |r| {
            var v = r;
            v.deinit(alloc);
        } else |_| {}
    }
    // Series-grp UDT initializer. InitUdtVSGrpConfig lives on
    // COtherServices (not the ...1 variant - report section 14). The
    // $record arg is udtVchSeriesGrpConfig (htype 50333725) with inert
    // defaults - the void initializer runs and writes nothing.
    {
        var oth_sess = try Session.init(alloc);
        defer oth_sess.deinit();
        try oth_sess.create("Busy2L21.COtherServices");
        try ops.openCompany(&oth_sess, .{ .prog_id = "Busy2L21.COtherServices", .busy = busy, .data = data, .comp = comp });
        rec.sess = &oth_sess;
        defer rec.sess = sess;
        const empty_coll: json.Value = .{ .arr = @constCast(&[_]json.Value{}) };
        const coll_entry = [_]json.Value.Entry{.{ .key = "$collection", .val = empty_coll }};
        var udt_fields = [_]json.Value.Entry{
            .{ .key = "tmpVchSerGrpCode", .val = .{ .int = 0 } },
            .{ .key = "VchSerGrpName", .val = .{ .str = "" } },
            .{ .key = "VchSeriesCodeCol", .val = .{ .obj = @constCast(&coll_entry) } },
            .{ .key = "tmpVchSeriesNameCol", .val = .{ .obj = @constCast(&coll_entry) } },
            .{ .key = "VatAccCol", .val = .{ .obj = @constCast(&coll_entry) } },
            .{ .key = "tmpVatAccNameCol", .val = .{ .obj = @constCast(&coll_entry) } },
        };
        var udt_rec = [_]json.Value.Entry{
            .{ .key = "htype", .val = .{ .int = 50333725 } },
            .{ .key = "fields", .val = .{ .obj = @constCast(&udt_fields) } },
        };
        const record_arg: json.Value = .{ .obj = @constCast(&[_]json.Value.Entry{.{ .key = "$record", .val = .{ .obj = @constCast(&udt_rec) } }}) };
        var init_args = [_]json.Value{record_arg};
        if (rec.recordInvoke("InitUdtVSGrpConfig", &init_args)) |r| {
            var v = r;
            v.deinit(alloc);
        } else |_| {}
    }
}
