//! Shared text helpers: no wire-format knowledge, no BUSY knowledge.
const std = @import("std");

const Allocator = std.mem.Allocator;
const Io = std.Io;

pub fn eql(a: []const u8, b: []const u8) bool {
    return std.mem.eql(u8, a, b);
}

pub fn startsWithCi(hay: []const u8, needle: []const u8) bool {
    if (hay.len < needle.len) return false;
    return std.ascii.eqlIgnoreCase(hay[0..needle.len], needle);
}

/// Decode a base64 CLI value. Used by --args-b64/--sql-b64 because
/// PowerShell 5.1 mangles embedded double quotes in native-command args.
pub fn b64Decode(alloc: Allocator, s: []const u8) ![]u8 {
    const dec = std.base64.standard.Decoder;
    const size = try dec.calcSizeForSlice(s);
    const buf = try alloc.alloc(u8, size);
    errdefer alloc.free(buf);
    try dec.decode(buf, s);
    return buf;
}

pub fn printOut(io: Io, alloc: Allocator, text: []const u8) !void {
    _ = alloc;
    var buf: [16384]u8 = undefined;
    // writerStreaming, NOT writer: the default positional writer starts at
    // pos=0, so every flush issues NtWriteFile with ByteOffset=0. When
    // stdout is a FILE redirect each printOut call therefore overwrites
    // from file offset 0 (multi-call outputs corrupt: the trailing "\n"
    // eats "{", the last Usage write wins). Pipes and consoles ignore the
    // explicit offset, which is why they were unaffected. Streaming mode
    // passes ByteOffset=NULL and appends at the file object's current
    // position; for pipes/consoles it is byte-identical to today.
    var w = Io.File.stdout().writerStreaming(io, &buf);
    try w.interface.writeAll(text);
    try w.interface.flush();
}

/// Percent-decode a query-string value (`%XX` only; '+' stays literal —
/// query components use %20 for spaces, not form encoding).
pub fn urlDecode(alloc: Allocator, s: []const u8) ![]u8 {
    if (std.mem.indexOfScalar(u8, s, '%') == null) return alloc.dupe(u8, s);
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var i: usize = 0;
    while (i < s.len) {
        if (s[i] == '%' and i + 2 < s.len) {
            const hx = std.fmt.parseInt(u8, s[i + 1 .. i + 3], 16) catch {
                try out.append(alloc, '%');
                i += 1;
                continue;
            };
            try out.append(alloc, hx);
            i += 3;
            continue;
        }
        try out.append(alloc, s[i]);
        i += 1;
    }
    return out.toOwnedSlice(alloc);
}

test "urlDecode" {
    const testing = std.testing;
    const a = try urlDecode(testing.allocator, "a%20b/c");
    defer testing.allocator.free(a);
    const b = try urlDecode(testing.allocator, "%5Bfalse%5D");
    defer testing.allocator.free(b);
    const c = try urlDecode(testing.allocator, "50%");
    defer testing.allocator.free(c);
    const d = try urlDecode(testing.allocator, "a+b");
    defer testing.allocator.free(d);
    const e = try urlDecode(testing.allocator, "plain");
    defer testing.allocator.free(e);
    try testing.expectEqualStrings("a b/c", a);
    try testing.expectEqualStrings("[false]", b);
    try testing.expectEqualStrings("50%", c); // bare % kept
    try testing.expectEqualStrings("a+b", d); // '+' untouched
    try testing.expectEqualStrings("plain", e);
}

/// Stable machine code for a Zig error: "InvokeFailed" -> "invoke_failed".
/// Returned slice points into `buf` (caller-owned stack buffer).
pub fn errCode(err: anyerror, buf: []u8) []const u8 {
    const name = @errorName(err);
    var o: usize = 0;
    for (name, 0..) |ch, i| {
        const upper = std.ascii.isUpper(ch);
        if (upper and i > 0 and o + 2 < buf.len) {
            buf[o] = '_';
            o += 1;
        }
        if (o >= buf.len) break;
        buf[o] = std.ascii.toLower(ch);
        o += 1;
    }
    return buf[0..o];
}

test "errCode" {
    const testing = std.testing;
    var b: [64]u8 = undefined;
    try testing.expectEqualStrings("invoke_failed", errCode(error.InvokeFailed, &b));
    try testing.expectEqualStrings("bad_document", errCode(error.BadDocument, &b));
    try testing.expectEqualStrings("open_db_failed", errCode(error.OpenDbFailed, &b));
    try testing.expectEqualStrings("unexpected_char", errCode(error.UnexpectedChar, &b));
    // issue #6: unrunnable SQL -> distinct machine code
    try testing.expectEqualStrings("no_recordset", errCode(error.NoRecordset, &b));
}

/// OLE Automation date (days since 1899-12-30) -> BUSY's display format
/// "DD/MM/YYYY". Used for VT_DATE variants (facade M1: Tran1.Date). Uses
/// Howard Hinnant's civil-from-days algorithm.
pub fn oleDateToText(buf: []u8, ole: f64) ![]u8 {
    const days_1970: i64 = @as(i64, @intFromFloat(@floor(ole))) - 25569;
    const z: i64 = days_1970 + 719468;
    const era: i64 = @divFloor(z, 146097);
    const doe: i64 = z - era * 146097; // [0, 146096]
    // all operands are non-negative for valid dates -> truncating division
    const yoe: i64 = @divTrunc(doe - @divTrunc(doe, 1460) + @divTrunc(doe, 36524) - @divTrunc(doe, 146096), 365); // [0, 399]
    const y: i64 = yoe + era * 400;
    const doy: i64 = doe - (365 * yoe + @divTrunc(yoe, 4) - @divTrunc(yoe, 100)); // [0, 365]
    const mp: i64 = @divTrunc(5 * doy + 2, 153); // [0, 11]
    const d: i64 = doy - @divTrunc(153 * mp + 2, 5) + 1; // [1, 31]
    const m: i64 = if (mp < 10) mp + 3 else mp - 9; // [1, 12]
    const yy: i64 = if (m <= 2) y + 1 else y;
    // NOTE: {d:0>2} zero-pads only for unsigned operands (signed positive
    // values print "+1" on Zig 0.17) — cast the day/month fields.
    return std.fmt.bufPrint(buf, "{d:0>2}/{d:0>2}/{d}", .{ @as(u64, @intCast(d)), @as(u64, @intCast(m)), yy });
}

/// ISO `YYYY-MM-DD`, BUSY `DD-MM-YYYY` or `DD/MM/YYYY` -> OLE Automation
/// days (1899-12-30 epoch). Inverse of oleDateToText; feeds VT_DATE
/// arguments (services-class report methods date-type their params).
pub fn dateToOle(s: []const u8) ?f64 {
    if (s.len != 10) return null;
    var y: i64 = 0;
    var m: i64 = 0;
    var d: i64 = 0;
    if ((s[4] == '-' or s[4] == '/') and s[7] == s[4]) { // YYYY-MM-DD
        y = std.fmt.parseInt(i64, s[0..4], 10) catch return null;
        m = std.fmt.parseInt(i64, s[5..7], 10) catch return null;
        d = std.fmt.parseInt(i64, s[8..10], 10) catch return null;
    } else if ((s[2] == '-' or s[2] == '/') and s[5] == s[2]) { // DD-MM-YYYY / DD/MM/YYYY
        d = std.fmt.parseInt(i64, s[0..2], 10) catch return null;
        m = std.fmt.parseInt(i64, s[3..5], 10) catch return null;
        y = std.fmt.parseInt(i64, s[6..10], 10) catch return null;
    } else return null;
    if (y < 1 or m < 1 or m > 12 or d < 1 or d > 31) return null;
    return @as(f64, @floatFromInt(daysFromCivil(y, m, d) + 25569));
}

/// Howard Hinnant days_from_civil: days since 1970-01-01.
fn daysFromCivil(y_in: i64, m: i64, d_in: i64) i64 {
    const y = y_in - @as(i64, if (m <= 2) 1 else 0);
    const era: i64 = @divFloor((if (y >= 0) y else y - 399), 400);
    const yoe = y - era * 400; // [0, 399]
    const mp: i64 = if (m > 2) m - 3 else m + 9; // [0, 11]
    const doy = @divFloor(153 * mp + 2, 5) + d_in - 1; // [0, 365]
    const doe = yoe * 365 + @divTrunc(yoe, 4) - @divTrunc(yoe, 100) + doy; // [0, 146096]
    return era * 146097 + doe - 719468;
}

test "dateToOle round-trips with oleDateToText" {
    const testing = std.testing;
    var b: [16]u8 = undefined;
    try testing.expectEqual(@as(f64, 25569.0), dateToOle("1970-01-01").?);
    try testing.expectEqual(@as(f64, 46303.0), dateToOle("2026-10-08").?);
    try testing.expectEqual(@as(f64, 46303.0), dateToOle("08-10-2026").?);
    try testing.expectEqual(@as(f64, 46303.0), dateToOle("08/10/2026").?);
    // round-trip: OLE -> text -> OLE
    const txt = try oleDateToText(&b, 46113.0); // 2026-04-01
    try testing.expectEqualStrings("01/04/2026", txt);
    try testing.expectEqual(@as(f64, 46113.0), dateToOle(txt).?);
    try testing.expect(dateToOle("garbage") == null);
    try testing.expect(dateToOle("2026-13-01") == null);
}

test "oleDateToText" {
    const testing = std.testing;
    var b: [16]u8 = undefined;
    try testing.expectEqualStrings("01/01/1970", try oleDateToText(&b, 25569.0));
    try testing.expectEqualStrings("30/12/1899", try oleDateToText(&b, 0.0));
    try testing.expectEqualStrings("08/10/2026", try oleDateToText(&b, 46303.0)); // 2026-10-08
    // fractional time-of-day floors to the date
    try testing.expectEqualStrings("08/10/2026", try oleDateToText(&b, 46303.75));
}

/// SQL string-literal body: single quotes doubled ('' escape). The caller
/// wraps the result in quotes: `Name = '{s}'`. Owned — caller frees.
pub fn sqlQuote(alloc: Allocator, s: []const u8) ![]u8 {
    var extra: usize = 0;
    for (s) |c| {
        if (c == '\'') extra += 1;
    }
    var out = try alloc.alloc(u8, s.len + extra);
    var i: usize = 0;
    for (s) |c| {
        out[i] = c;
        i += 1;
        if (c == '\'') {
            out[i] = '\'';
            i += 1;
        }
    }
    return out;
}

test "sqlQuote" {
    const testing = std.testing;
    const a = testing.allocator;
    const plain = try sqlQuote(a, "Sundry Debtors");
    defer a.free(plain);
    try testing.expectEqualStrings("Sundry Debtors", plain);
    const evil = try sqlQuote(a, "x'; DROP TABLE Master1; --");
    defer a.free(evil);
    // input contains one literal quote -> doubled by quoting
    try testing.expectEqualStrings("x''; DROP TABLE Master1; --", evil);
    const q = try sqlQuote(a, "it''s");
    defer a.free(q);
    try testing.expectEqualStrings("it''''s", q); // each ' doubles
}
