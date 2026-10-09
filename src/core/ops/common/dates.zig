//! Date conversions for the ERP ops (issue #7 / 011 phase 2): BUSY
//! display forms <-> ISO. Pure string transforms — no session, no
//! BUSY knowledge. Owned results; null = unrecognized input (caller
//! keeps the raw text — robustness over strictness).
const std = @import("std");

const Allocator = std.mem.Allocator;

/// Date -> ISO `YYYY-MM-DD`. Accepts BUSY's display forms `DD/MM/YYYY`
/// and `DD-MM-YYYY`, passes ISO through; anything else returns null.
pub fn normalizeDate(alloc: Allocator, s: []const u8) anyerror!?[]u8 {
    if (s.len == 10 and s[4] == '-' and s[7] == '-') return try alloc.dupe(u8, s); // already ISO
    if (s.len == 10 and (s[2] == '/' or s[2] == '-') and s[5] == s[2]) {
        return try std.fmt.allocPrint(alloc, "{s}-{s}-{s}", .{ s[6..10], s[3..5], s[0..2] });
    }
    return null;
}

/// Inverse: ISO `YYYY-MM-DD` (or already-BUSY `DD-MM-YYYY`/`DD/MM/YYYY`)
/// -> BUSY's write format `DD-MM-YYYY` (what SaveVchFromXML expects —
/// the vendor templates and every live write used dashes).
pub fn toBusyDate(alloc: Allocator, s: []const u8) anyerror!?[]u8 {
    if (s.len == 10 and s[2] == '-' and s[5] == '-' and s[6] >= '0' and s[6] <= '9')
        return try alloc.dupe(u8, s); // already DD-MM-YYYY
    if (s.len == 10 and s[2] == '/' and s[5] == '/' and s[6] >= '0' and s[6] <= '9')
        return try std.fmt.allocPrint(alloc, "{s}-{s}-{s}", .{ s[0..2], s[3..5], s[6..10] });
    if (s.len == 10 and s[4] == '-' and s[7] == '-') // ISO
        return try std.fmt.allocPrint(alloc, "{s}-{s}-{s}", .{ s[8..10], s[5..7], s[0..4] });
    return null;
}

// ---------------- tests ----------------

const testing = std.testing;

test "normalizeDate" {
    const a = testing.allocator;
    const iso = (try normalizeDate(a, "2026-10-08")).?;
    defer a.free(iso);
    try testing.expectEqualStrings("2026-10-08", iso);
    const slash = (try normalizeDate(a, "08/10/2026")).?;
    defer a.free(slash);
    try testing.expectEqualStrings("2026-10-08", slash);
    const dash = (try normalizeDate(a, "08-10-2026")).?;
    defer a.free(dash);
    try testing.expectEqualStrings("2026-10-08", dash);
    try testing.expect((try normalizeDate(a, "not a date")) == null);
    try testing.expect((try normalizeDate(a, "8/10/2026")) == null);
}

test "toBusyDate write format" {
    const a = testing.allocator;
    const iso = (try toBusyDate(a, "2026-10-08")).?;
    defer a.free(iso);
    try testing.expectEqualStrings("08-10-2026", iso);
    const busy = (try toBusyDate(a, "08-10-2026")).?;
    defer a.free(busy);
    try testing.expectEqualStrings("08-10-2026", busy); // idempotent
    const slash = (try toBusyDate(a, "08/10/2026")).?;
    defer a.free(slash);
    try testing.expectEqualStrings("08-10-2026", slash);
    try testing.expect((try toBusyDate(a, "garbage")) == null);
    // round-trip with normalizeDate (free the intermediate conversion)
    const intermediate = (try toBusyDate(a, "2026-01-02")).?;
    defer a.free(intermediate);
    const rt = (try normalizeDate(a, intermediate)).?;
    defer a.free(rt);
    try testing.expectEqualStrings("2026-01-02", rt);
}
