//! SQL guardrail for the query facility (issue #3).
//!
//! Parser-light validation: first-keyword + statement-boundary checks.
//! This is a **guardrail, not a SQL firewall** — it stops casual
//! `DELETE/DROP` and multi-statement smuggling through `query`, but true
//! isolation needs read-only database credentials (documented in README).
//!
//! Layer: util (pure text logic, std-only) — both transports apply it.
const std = @import("std");

/// Per-process query mode (`--query-mode`).
/// - `full`: current behavior — any SQL runs (CLI default).
/// - `read_only`: a single `SELECT`/`WITH` statement only (serve default).
/// - `off`: the query facility refuses everything.
pub const Mode = enum { full, read_only, off };

/// Parse a `--query-mode` flag value (canonical names + friendly aliases).
pub fn parseMode(s: []const u8) ?Mode {
    if (std.ascii.eqlIgnoreCase(s, "full")) return .full;
    if (std.ascii.eqlIgnoreCase(s, "read-only") or
        std.ascii.eqlIgnoreCase(s, "readonly") or
        std.ascii.eqlIgnoreCase(s, "read_only")) return .read_only;
    if (std.ascii.eqlIgnoreCase(s, "off")) return .off;
    return null;
}

/// Refuse `sql` under `mode`. The transport maps this to the stable
/// machine code `query_not_allowed` (HTTP 403 / CLI exit 1).
pub fn check(mode: Mode, sql: []const u8) error{QueryNotAllowed}!void {
    switch (mode) {
        .full => {},
        .off => return error.QueryNotAllowed,
        .read_only => try readOnly(sql),
    }
}

fn isIdent(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
        (c >= '0' and c <= '9') or c == '_';
}

fn isSpace(c: u8) bool {
    return c == ' ' or c == '\t' or c == '\n' or c == '\r' or c == '\x0B' or c == '\x0C';
}

/// read-only acceptance: the first bare word (after whitespace and
/// comments) must be SELECT or WITH, and nothing but whitespace/comments
/// may follow a statement-terminating semicolon. String literals (''
/// escapes), quoted identifiers, and `--` / `/* */` comments are scanned
/// past so `SELECT ';'` passes and `SELECT 1; DROP TABLE x` does not.
fn readOnly(sql: []const u8) error{QueryNotAllowed}!void {
    const n = sql.len;
    var i: usize = 0;

    // phase 1: skip leading whitespace + comments, then read first keyword
    while (i < n) {
        const c = sql[i];
        if (isSpace(c)) {
            i += 1;
        } else if (c == '-' and i + 1 < n and sql[i + 1] == '-') {
            while (i < n and sql[i] != '\n') i += 1;
        } else if (c == '/' and i + 1 < n and sql[i + 1] == '*') {
            i += 2;
            while (i + 1 < n and !(sql[i] == '*' and sql[i + 1] == '/')) i += 1;
            if (i + 1 >= n) return error.QueryNotAllowed; // unterminated comment
            i += 2;
        } else break;
    }
    const kw_start = i;
    while (i < n and isIdent(sql[i])) i += 1;
    const kw = sql[kw_start..i];
    if (!(std.ascii.eqlIgnoreCase(kw, "select") or std.ascii.eqlIgnoreCase(kw, "with")))
        return error.QueryNotAllowed;

    // phase 2: after the first keyword, scan statement boundaries
    var after_semi = false;
    while (i < n) {
        const c = sql[i];
        if (isSpace(c)) {
            i += 1;
            continue;
        }
        if (c == '\'') {
            if (after_semi) return error.QueryNotAllowed; // content after ';'
            i += 1;
            while (i < n) {
                if (sql[i] == '\'') {
                    if (i + 1 < n and sql[i + 1] == '\'') { // '' escape
                        i += 2;
                        continue;
                    }
                    i += 1;
                    break;
                }
                i += 1;
            }
            continue;
        }
        if (c == '"') {
            if (after_semi) return error.QueryNotAllowed;
            i += 1;
            while (i < n and sql[i] != '"') i += 1;
            if (i < n) i += 1;
            continue;
        }
        if (c == '-' and i + 1 < n and sql[i + 1] == '-') {
            while (i < n and sql[i] != '\n') i += 1;
            continue;
        }
        if (c == '/' and i + 1 < n and sql[i + 1] == '*') {
            i += 2; // comments are whitespace — legal after a trailing ';'
            while (i + 1 < n and !(sql[i] == '*' and sql[i + 1] == '/')) i += 1;
            if (i + 1 >= n) i = n else i += 2;
            continue;
        }
        if (c == ';') {
            if (after_semi) return error.QueryNotAllowed; // multi-statement
            after_semi = true;
            i += 1;
            continue;
        }
        if (after_semi) return error.QueryNotAllowed; // bare content after ';'
        i += 1;
    }
}

// ---------------- tests ----------------

const testing = std.testing;

test "parseMode" {
    try testing.expectEqual(Mode.full, parseMode("full").?);
    try testing.expectEqual(Mode.read_only, parseMode("read-only").?);
    try testing.expectEqual(Mode.read_only, parseMode("READ_ONLY").?);
    try testing.expectEqual(Mode.off, parseMode("Off").?);
    try testing.expect(parseMode("yes") == null);
    try testing.expect(parseMode("") == null);
}

test "read-only accepts SELECT/WITH shapes" {
    const ok = [_][]const u8{
        "SELECT * FROM Master1",
        "  \n\t select TOP 1 Code from Master1",
        "-- leading comment\nSELECT Code FROM Master1",
        "/* block */ SELECT Code FROM Master1",
        "WITH x AS (SELECT 1) SELECT * FROM x",
        "SELECT ';' AS s",
        "SELECT a FROM t WHERE b = 'it''s; fine'",
        "SELECT Code FROM Master1;", // single trailing semicolon
        "SELECT Code FROM Master1; -- done",
        "SELECT*FROM Master1",
    };
    for (ok) |sql| try check(.read_only, sql);
}

test "read-only rejects statements and multi-statement smuggling" {
    const bad = [_][]const u8{
        "",
        "   \n\t ",
        "DELETE FROM Master1",
        "UPDATE Master1 SET Name = 'x'",
        "DROP TABLE Tran1",
        "insert into Master1 values (1)",
        "EXEC sp_who",
        "SELECT 1; DROP TABLE x",
        "SELECT Code FROM Master1; DELETE FROM Master1",
        "SELECT 1 ; 2",
        "SELECT 1;;",
        ";SELECT 1",
        "sselect 1",
        "WITHDRAW", // keyword must match exactly, not as a prefix
        "-- only a comment",
        "/* unterminated SELECT",
    };
    for (bad) |sql| try testing.expectError(error.QueryNotAllowed, check(.read_only, sql));
}

test "mode gates" {
    // full runs anything (current CLI behavior)
    try check(.full, "DELETE FROM Master1");
    try check(.full, "SELECT 1; DROP TABLE x");
    // off refuses everything — even a plain SELECT
    try testing.expectError(error.QueryNotAllowed, check(.off, "SELECT 1"));
    try testing.expectError(error.QueryNotAllowed, check(.off, ""));
}
