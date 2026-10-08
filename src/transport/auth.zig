//! Token auth & exposure policy for `serve` (issue #4): pure decisions the
//! HTTP layer asks. Scope: transport-edge token gate + safe-bind rule.
//! Deliberately NOT here: TLS (reverse proxy owns it), per-user auth/RBAC
//! (the operations facade and BUSY's company-level rights own that layer).
const std = @import("std");

/// A bind host is loopback when it is `localhost`, an address in
/// 127.0.0.0/8, or IPv6 `::1`. Everything else - `0.0.0.0`, `::`, LAN
/// IPs, other hostnames - is remote exposure and needs a token.
pub fn isLoopback(host: []const u8) bool {
    if (std.ascii.eqlIgnoreCase(host, "localhost")) return true;
    if (std.ascii.eqlIgnoreCase(host, "::1") or std.ascii.eqlIgnoreCase(host, "[::1]")) return true;
    // 127.0.0.0/8: exact dotted-quad shape starting with "127." so a
    // hostname like "127.example.com" cannot smuggle past the rule.
    if (host.len >= 8 and std.mem.startsWith(u8, host, "127.")) {
        var dots: u8 = 0;
        for (host) |c| {
            if (c == '.') dots += 1 else if (c < '0' or c > '9') return false;
        }
        return dots == 3;
    }
    return false;
}

/// The token value from an `Authorization` header (scheme matched
/// case-insensitively), or null when the header carries no bearer token.
pub fn bearerOf(header: []const u8) ?[]const u8 {
    const t = std.mem.trim(u8, header, " \t");
    if (t.len < 7) return null;
    if (!std.ascii.eqlIgnoreCase(t[0..6], "bearer")) return null;
    if (t[6] != ' ' and t[6] != '\t') return null;
    const v = std.mem.trim(u8, t[6..], " \t");
    return if (v.len == 0) null else v;
}

/// Constant-time compare (token length is not secret; content timing is).
fn eqConstTime(a: []const u8, b: []const u8) bool {
    if (a.len != b.len) return false;
    var diff: u8 = 0;
    for (a, 0..) |x, i| diff |= x ^ b[i];
    return diff == 0;
}

/// The per-request gate. Unarmed (no token configured, or empty token)
/// passes everything - that is the loopback-only mode, byte-identical to
/// pre-issue-#4 behavior. When armed: `/info` is exempt (capability
/// discovery, per the issue decision); every other path - including
/// `/health`, 404s, and unknown routes - needs the token via
/// `Authorization: Bearer <t>` or `X-Bridge-Token: <t>`.
pub fn authorized(
    token: ?[]const u8,
    path: []const u8,
    auth_header: []const u8,
    x_header: []const u8,
) bool {
    const want = token orelse return true;
    if (want.len == 0) return true;
    if (std.mem.eql(u8, path, "/info")) return true;
    if (bearerOf(auth_header)) |b| {
        if (eqConstTime(b, want)) return true;
    }
    const x = std.mem.trim(u8, x_header, " \t");
    if (x.len > 0 and eqConstTime(x, want)) return true;
    return false;
}

/// The start-time rule: a non-loopback bind requires a configured token.
/// Refusing to start is the whole point - fail fast, actionable message,
/// before any socket listens.
pub fn bindAllowed(token: ?[]const u8, host: []const u8) bool {
    if (token) |t| {
        if (t.len > 0) return true;
    }
    return isLoopback(host);
}

// ---------------- tests (pure, no COM/serve) ----------------

const testing = std.testing;

test "isLoopback: loopback forms" {
    try testing.expect(isLoopback("127.0.0.1"));
    try testing.expect(isLoopback("127.1.2.3"));
    try testing.expect(isLoopback("localhost"));
    try testing.expect(isLoopback("LOCALHOST"));
    try testing.expect(isLoopback("::1"));
    try testing.expect(isLoopback("[::1]"));
}

test "isLoopback: remote exposure forms" {
    try testing.expect(!isLoopback("0.0.0.0"));
    try testing.expect(!isLoopback("::"));
    try testing.expect(!isLoopback("192.168.1.10"));
    try testing.expect(!isLoopback("10.0.0.1"));
    try testing.expect(!isLoopback("example.internal"));
    try testing.expect(!isLoopback("127.example.com"));
    try testing.expect(!isLoopback("127.0.0.1.evil"));
    try testing.expect(!isLoopback(""));
}

test "bearerOf: scheme parsing" {
    try testing.expectEqualStrings("abc", bearerOf("Bearer abc") orelse "");
    try testing.expectEqualStrings("abc", bearerOf("bearer   abc") orelse "");
    try testing.expectEqualStrings("a b", bearerOf("BEARER a b") orelse "");
    try testing.expectEqualStrings("abc", bearerOf("  Bearer abc  ") orelse "");
    try testing.expect(bearerOf("") == null);
    try testing.expect(bearerOf("Basic abc") == null);
    try testing.expect(bearerOf("Bearer") == null);
    try testing.expect(bearerOf("Bearer    ") == null);
    try testing.expect(bearerOf("Bearerabc") == null);
}

test "authorized: unarmed loopback mode passes everything" {
    try testing.expect(authorized(null, "/query", "", ""));
    try testing.expect(authorized(null, "/anything", "", "junk"));
    try testing.expect(authorized("", "/query", "", "")); // empty = unset
}

test "authorized: armed gate" {
    const t = "s3cret";
    // /info exempt without token (issue decision), /health NOT exempt
    try testing.expect(authorized(t, "/info", "", ""));
    try testing.expect(!authorized(t, "/health", "", ""));
    try testing.expect(!authorized(t, "/query", "", ""));
    try testing.expect(!authorized(t, "/nope", "", "")); // 404s gated too
    // correct token, both headers
    try testing.expect(authorized(t, "/query", "Bearer s3cret", ""));
    try testing.expect(authorized(t, "/query", "bearer s3cret", ""));
    try testing.expect(authorized(t, "/query", "", "s3cret"));
    // wrong / missing / malformed
    try testing.expect(!authorized(t, "/query", "Bearer wrong", ""));
    try testing.expect(!authorized(t, "/query", "Bearer ", ""));
    try testing.expect(!authorized(t, "/query", "Basic s3cret", ""));
    try testing.expect(!authorized(t, "/query", "", "wrong"));
    try testing.expect(!authorized(t, "/query", "", "  "));
    // extra whitespace in x-header tolerated
    try testing.expect(authorized(t, "/query", "", " s3cret "));
}

test "bindAllowed: non-loopback requires a token" {
    try testing.expect(bindAllowed(null, "127.0.0.1")); // default is fine
    try testing.expect(!bindAllowed(null, "0.0.0.0")); // the core rule
    try testing.expect(!bindAllowed(null, "192.168.1.5"));
    try testing.expect(!bindAllowed("", "0.0.0.0")); // empty token = unset
    try testing.expect(bindAllowed("tok", "0.0.0.0")); // token unlocks
    try testing.expect(bindAllowed("tok", "127.0.0.1"));
}
