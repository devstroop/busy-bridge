//! Replay suites (issue 009): session-boundary scenarios over the seed
//! transcript, plus mismatch/error/staleness guards. Host-agnostic — the
//! same tests run in `zig build test` (Windows) and `zig build replay-test`
//! (Linux + Windows, no BUSY).
const std = @import("std");
const json = @import("../../../util/json.zig");
const xml = @import("../../../util/xml.zig");
const engine = @import("engine.zig");

const Replay = engine.Replay;
const testing = std.testing;
const golden = @embedFile("testdata/golden.jsonl");

fn openGolden() !Replay {
    return Replay.init(testing.allocator, golden, null);
}

test "replay golden header" {
    var r = try openGolden();
    defer r.deinit();
    try testing.expect(r.synthetic);
    try testing.expectEqualStrings("Rel 14", r.busy_version);
    try testing.expectEqual(@as(usize, 9), r.count());
    try testing.expect(!r.stale_warn);
}

test "replay golden walk (session-boundary scenarios)" {
    var r = try openGolden();
    defer r.deinit();
    const a = testing.allocator;

    // OpenDB ok.
    var open_args = [_]json.Value{ .{ .str = "C:\\BusyWin\\" }, .{ .str = "C:\\BusyWin\\DATA\\" }, .{ .str = "COMP0001" } };
    var ok = try r.invoke("OpenDB", &open_args);
    defer ok.deinit(a);
    try testing.expect(ok.ret == .bool and ok.ret.bool);

    // OpenDB failure maps + message preserved.
    var bad_args = [_]json.Value{ .{ .str = "C:\\BusyWin\\" }, .{ .str = "C:\\BusyWin\\DATA\\" }, .{ .str = "NOPE" } };
    try testing.expectError(error.OpenDbFailed, r.invoke("OpenDB", &bad_args));
    try testing.expect(std.mem.indexOf(u8, r.lastError(), "NOPE") != null);

    // Master write: args round-trip, ByRef out-param comes back.
    const doc = [_]json.Value.Entry{.{
        .key = "Account",
        .val = .{ .obj = @constCast(&[_]json.Value.Entry{
            .{ .key = "Name", .val = .{ .str = "Replay" } },
            .{ .key = "ParentGroup", .val = .{ .str = "Sundry Debtors" } },
        }) },
    }};
    var save_args = [_]json.Value{
        .{ .int = 2 },
        .{ .obj = @constCast(&doc) },
        .{ .obj = @constCast(&[_]json.Value.Entry{.{ .key = "$byref", .val = .{ .str = "" } }}) },
        .{ .bool = false },
    };
    var saved = try r.invoke("SaveMasterFromXML", &save_args);
    defer saved.deinit(a);
    try testing.expect(saved.ret == .bool and saved.ret.bool);
    try testing.expectEqual(@as(usize, 1), saved.outs.len);

    // GetMasterXML: raw doc string passes through byte-identical.
    var get_args = [_]json.Value{ .{ .int = 2 }, .{ .str = "Replay" } };
    var got = try r.invoke("GetMasterXML", &get_args);
    defer got.deinit(a);
    try testing.expect(got.ret == .str);
    try testing.expect(std.mem.indexOf(u8, got.ret.str, "<Name>Replay</Name>") != null);

    // Recordset: multi-row with a null cell.
    var rows = try r.queryToJson("SELECT TOP 2 Code, Name FROM Master1");
    defer rows.deinit(a);
    try testing.expect(rows == .arr and rows.arr.len == 2);
    try testing.expect((rows.arr[1].get("Name").?).* == .null);

    // Empty recordset is a value, not an error.
    var empty = try r.queryToJson("SELECT Code FROM Master1 WHERE 1=0");
    defer empty.deinit(a);
    try testing.expect(empty == .arr and empty.arr.len == 0);

    // Tran1 no-recordset error maps.
    var tran_args = [_]json.Value{.{ .str = "2026-01-01" }};
    try testing.expectError(error.NoRecordset, r.invoke("Tran1", &tran_args));
    try testing.expect(std.mem.indexOf(u8, r.lastError(), "no recordset") != null);

    // Company config doc.
    var cfg = try r.invoke("GetCompConfigXML", &[_]json.Value{});
    defer cfg.deinit(a);
    try testing.expect(cfg.ret == .str);

    // Unknown member error maps.
    try testing.expectError(error.NoSuchMember, r.invoke("NoSuchMethod", &[_]json.Value{}));
}

test "replay rejects method mismatch without consuming" {
    const t =
        \\{"format":"busy-bridge-transcript/1","recorded_at":"t","busy_version":"Rel 14","prog_id":"P","synthetic":true}
        \\{"seq":1,"op":"invoke","method":"OpenDB","args":[],"ok":true,"ret":true,"outs":[]}
    ;
    var r = try Replay.init(testing.allocator, t, null);
    defer r.deinit();
    try testing.expectError(error.StaleTranscript, r.invoke("CloseDB", &[_]json.Value{}));
    // Entry unconsumed: the right call still succeeds.
    var ok = try r.invoke("OpenDB", &[_]json.Value{});
    defer ok.deinit(testing.allocator);
    try testing.expect(ok.ret == .bool);
}

test "replay rejects args mismatch" {
    const t =
        \\{"format":"busy-bridge-transcript/1","recorded_at":"t","busy_version":"Rel 14","prog_id":"P","synthetic":true}
        \\{"seq":1,"op":"invoke","method":"OpenDB","args":["COMP0001"],"ok":true,"ret":true,"outs":[]}
    ;
    var r = try Replay.init(testing.allocator, t, null);
    defer r.deinit();
    var wrong = [_]json.Value{.{ .str = "COMP0002" }};
    try testing.expectError(error.StaleTranscript, r.invoke("OpenDB", &wrong));
}

test "replay rejects wrong op kind and exhaustion" {
    const t =
        \\{"format":"busy-bridge-transcript/1","recorded_at":"t","busy_version":"Rel 14","prog_id":"P","synthetic":true}
        \\{"seq":1,"op":"query","sql":"SELECT 1","ok":true,"rows":[]}
    ;
    var r = try Replay.init(testing.allocator, t, null);
    defer r.deinit();
    try testing.expectError(error.StaleTranscript, r.invoke("SELECT 1", &[_]json.Value{}));
    var rows = try r.queryToJson("SELECT 1");
    defer rows.deinit(testing.allocator);
    try testing.expectError(error.StaleTranscript, r.queryToJson("SELECT 1"));
}

test "replay maps recorded error names" {
    const t =
        \\{"format":"busy-bridge-transcript/1","recorded_at":"t","busy_version":"Rel 14","prog_id":"P","synthetic":true}
        \\{"seq":1,"op":"invoke","method":"A","args":[],"ok":false,"error":"BadArgs","message":"bad"}
        \\{"seq":2,"op":"invoke","method":"B","args":[],"ok":false,"error":"BusyRejected","message":"rejected"}
        \\{"seq":3,"op":"invoke","method":"C","args":[],"ok":false,"error":"NoSuchThing","message":"?"}
    ;
    var r = try Replay.init(testing.allocator, t, null);
    defer r.deinit();
    try testing.expectError(error.BadArgs, r.invoke("A", &[_]json.Value{}));
    try testing.expect(std.mem.indexOf(u8, r.lastError(), "bad") != null);
    try testing.expectError(error.BusyRejected, r.invoke("B", &[_]json.Value{}));
    try testing.expectError(error.ReplayUnknownError, r.invoke("C", &[_]json.Value{}));
}

test "replay XML doc result parses via pure codec" {
    const t =
        \\{"format":"busy-bridge-transcript/1","recorded_at":"t","busy_version":"Rel 14","prog_id":"P","synthetic":true}
        \\{"seq":1,"op":"invoke","method":"GetCompConfigXML","args":[],"ok":true,"ret":"<Company><CompanyName>DEMO</CompanyName></Company>","outs":[]}
    ;
    var r = try Replay.init(testing.allocator, t, null);
    defer r.deinit();
    var res = try r.invoke("GetCompConfigXML", &[_]json.Value{});
    defer res.deinit(testing.allocator);
    var doc = try xml.parse(testing.allocator, res.ret.str);
    defer doc.deinit(testing.allocator);
    try testing.expectEqualStrings("Company", doc.name);
    var name: ?[]const u8 = null;
    for (doc.children) |*n| {
        if (n.* == .element and std.mem.eql(u8, n.element.name, "CompanyName")) {
            for (n.element.children) |*c| if (c.* == .text) {
                name = c.text;
            };
        }
    }
    try testing.expectEqualStrings("DEMO", name.?);
}

test "replay transcript line round-trips through stringify" {
    var it = std.mem.splitScalar(u8, golden, '\n');
    var saw_entry = false;
    while (it.next()) |raw| {
        const t = std.mem.trim(u8, raw, " \t\r");
        if (t.len == 0 or std.mem.indexOf(u8, t, "\"seq\"") == null) continue;
        saw_entry = true;
        var v = try json.parse(testing.allocator, t);
        defer v.deinit(testing.allocator);
        var buf: std.ArrayList(u8) = .empty;
        defer buf.deinit(testing.allocator);
        var w = json.Writer{ .buf = &buf, .alloc = testing.allocator };
        try json.stringify(&v, &w);
        var v2 = try json.parse(testing.allocator, buf.items);
        defer v2.deinit(testing.allocator);
        var buf2: std.ArrayList(u8) = .empty;
        defer buf2.deinit(testing.allocator);
        var w2 = json.Writer{ .buf = &buf2, .alloc = testing.allocator };
        try json.stringify(&v2, &w2);
        try testing.expectEqualStrings(buf.items, buf2.items);
    }
    try testing.expect(saw_entry);
}

test "replay staleness flag on busy_version mismatch" {
    var same = try Replay.init(testing.allocator, golden, "Rel 14");
    defer same.deinit();
    try testing.expect(!same.stale_warn);
    var drifted = try Replay.init(testing.allocator, golden, "Rel 13");
    defer drifted.deinit();
    try testing.expect(drifted.stale_warn);
    try testing.expectEqualStrings("Rel 14", drifted.busy_version);
}
