//! User session tokens (BUSY-010; contract: docs/auth-contract.md §1).
//!
//! Two-tier credentials: the device token (`auth.zig`) gates the
//! transport; these opaque user sessions carry identity — token,
//! validated BUSY username, company binding, FY. Single-threaded
//! serve means a plain list is the store; tokens are 256-bit CSPRNG,
//! base64url (43 chars), never logged, compared constant-time.
//! Passwords never touch this module.
const std = @import("std");

const Allocator = std.mem.Allocator;

const win32 = @import("../core/com/win32.zig");

/// Contract §1 defaults (overridable at serve start).
pub const DEFAULT_IDLE_TTL_SECS: i64 = 12 * 3600; // 12 h idle
pub const DEFAULT_ABS_TTL_SECS: i64 = 7 * 24 * 3600; // 7 d absolute

pub const UserSession = struct {
    /// Owned base64url token (no padding).
    token: []u8,
    /// Owned validated BUSY username (attribution identity).
    user: []u8,
    /// Owned company code this session is bound to.
    company: []u8,
    fy: i64,
    created: i64, // unix seconds
    last_seen: i64,

    fn deinit(self: *UserSession, alloc: Allocator) void {
        alloc.free(self.token);
        alloc.free(self.user);
        alloc.free(self.company);
    }
};

pub const UserSessions = struct {
    alloc: Allocator,
    entries: std.ArrayList(UserSession) = .empty,
    idle_ttl: i64 = DEFAULT_IDLE_TTL_SECS,
    abs_ttl: i64 = DEFAULT_ABS_TTL_SECS,

    pub fn init(alloc: Allocator) UserSessions {
        return .{ .alloc = alloc };
    }

    pub fn deinit(self: *UserSessions) void {
        for (self.entries.items) |*e| e.deinit(self.alloc);
        self.entries.deinit(self.alloc);
    }

    /// Issue a session for a validated identity (BUSY-011: only after
    /// ValidUserPassword returned true). Returns the owned token —
    /// transfer to the caller for the wire; the store keeps its copy.
    pub fn issue(self: *UserSessions, user: []const u8, company: []const u8, fy: i64, now: i64) ![]u8 {
        var raw: [32]u8 = undefined;
        win32.secureRandom(&raw);
        var tok_buf: [43]u8 = undefined;
        const tok = std.base64.url_safe_no_pad.Encoder.encode(&tok_buf, &raw);
        const token = try self.alloc.dupe(u8, tok);
        errdefer self.alloc.free(token);
        try self.entries.append(self.alloc, .{
            .token = token,
            .user = try self.alloc.dupe(u8, user),
            .company = try self.alloc.dupe(u8, company),
            .fy = fy,
            .created = now,
            .last_seen = now,
        });
        return token;
    }

    /// Verify + touch. Returns the live entry (valid in the store until
    /// the next mutation) or null for unknown/expired tokens.
    pub fn verify(self: *UserSessions, token: []const u8, now: i64) ?*UserSession {
        if (token.len == 0) return null;
        for (self.entries.items) |*e| {
            if (!eqlConstTime(e.token, token)) continue;
            if (now - e.last_seen > self.idle_ttl or now - e.created > self.abs_ttl) {
                _ = self.removeByToken(token);
                return null;
            }
            e.last_seen = now;
            return e;
        }
        return null;
    }

    /// Idempotent revoke (contract §2 /auth/logout).
    pub fn revoke(self: *UserSessions, token: []const u8) bool {
        return self.removeByToken(token);
    }

    fn removeByToken(self: *UserSessions, token: []const u8) bool {
        for (self.entries.items, 0..) |*e, i| {
            if (!eqlConstTime(e.token, token)) continue;
            e.deinit(self.alloc);
            _ = self.entries.orderedRemove(i);
            return true;
        }
        return false;
    }
};

fn eqlConstTime(a: []const u8, b: []const u8) bool {
    if (a.len != b.len) return false;
    var diff: u8 = 0;
    for (a, 0..) |x, i| diff |= x ^ b[i];
    return diff == 0;
}

// ---------------- tests (pure, no COM) ----------------

const testing = std.testing;

test "user sessions: issue/verify/revoke lifecycle" {
    var us = UserSessions.init(testing.allocator);
    defer us.deinit();
    const t = try us.issue("Admin", "COMP0001", 0, 1000);
    try testing.expectEqual(@as(usize, 43), t.len); // 32B -> b64url no pad
    const e = us.verify(t, 1001) orelse return error.TestUnexpectedResult;
    try testing.expectEqualStrings("Admin", e.user);
    try testing.expectEqualStrings("COMP0001", e.company);
    try testing.expectEqual(@as(i64, 0), e.fy);
    // unknown token
    try testing.expect(us.verify("bogus", 1001) == null);
    // revoke idempotent
    try testing.expect(us.revoke(t));
    try testing.expect(!us.revoke(t));
    try testing.expect(us.verify(t, 1002) == null);
    try testing.expectEqual(@as(usize, 0), us.entries.items.len);
}

test "user sessions: idle + absolute expiry" {
    var us = UserSessions.init(testing.allocator);
    defer us.deinit();
    us.idle_ttl = 100;
    us.abs_ttl = 1000;
    const t = try us.issue("user1", "C", 0, 0);
    // touched continuously: alive past idle window
    _ = us.verify(t, 50).?;
    _ = us.verify(t, 100).?;
    // idle expiry: no touch for > idle_ttl
    try testing.expect(us.verify(t, 101 + 100) == null);
    const t2 = try us.issue("user1", "C", 0, 850); // created=850
    // fresh enough for idle (50s < 100s), alive
    _ = us.verify(t2, 900).?;
    // absolute expiry: age 1001s > 1000s even though last touched 951s ago
    try testing.expect(us.verify(t2, 1851) == null);
    // expired tokens are removed, not just rejected
    try testing.expectEqual(@as(usize, 0), us.entries.items.len);
}

test "user sessions: distinct tokens per issue" {
    var us = UserSessions.init(testing.allocator);
    defer us.deinit();
    const a = try us.issue("Admin", "C1", 0, 0);
    const b = try us.issue("Admin", "C1", 0, 0);
    try testing.expect(!std.mem.eql(u8, a, b));
}
