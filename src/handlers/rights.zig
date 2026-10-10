//! Per-user rights resolution (BUSY-012; contract: docs/auth-contract.md §3).
//!
//! Probe-verified (iteration 7, 2026-10-10, live COMP0001):
//! `CheckUserRightsForReports(p_UserName, p_RepID, p_BranchCode,
//! p_VchSeriesGrpCode, p_masterSeriesGrpCode, p_MastName, p_ErrStr)`
//! on `COtherServices1` answers per-user, per-report:
//! - super user (admin): true across the verified repID space
//! - user1 (regular): false for 0–15, **true for 19 (Account Ledger)
//!   and 201 (Bills Rec/Pay)** — real per-report discrimination
//! - bogus repID 99999: DISP_E_OVERFLOW (0x8002000a) — p_RepID is a
//!   VB6 Integer (max 32767); semantic validity of in-range IDs is
//!   otherwise unconfirmed (admin answers true for every in-range ID)
//! `GetRightsMsg` -> " do not have the rights " (BUSY's fragment).
//! `GetVchTypesForUserRights` -> Collection (enumeration gap defers the
//! voucher-type key space); no master/voucher rights primitive exists.
//! Rights are therefore BUSY-backed for reports, deny-by-default
//! everywhere else (contract §3).
const std = @import("std");
const json = @import("../util/json.zig");
const busyc = @import("../core/com.zig");
const common = @import("common.zig");
const authz = @import("auth.zig");

const Allocator = std.mem.Allocator;

/// The empirically + documentarily verified repID space: contiguous
/// 0–15 (live sweep) plus documented IDs (BUSY Functions.md):
/// 19 = Account Ledger, 21 = Account Register, 201 = Bills Rec/Pay.
/// All fit VB6 Integer. Extend via probe sweep as more reports land.
pub const rep_ids = [_]i64{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 19, 21, 201 };

/// Resolve normalized rights (contract §3) for `user` through BUSY's
/// own per-user report-rights primitive. Super user short-circuits to
/// full rights (the probe shows BUSY answers the super user
/// unconditionally true — no row check). Regular users get one
/// `CheckUserRightsForReports` call per repID via a transient
/// COtherServices1 aux (company state is process-global); any invoke
/// error fails CLOSED for that report (contract: unknown ⇒ deny).
/// `voucher_types`/`masters` stay `{}`: their key spaces are blocked
/// on Collection enumeration / have no COM primitive.
pub fn resolve(sess: *busyc.Session, alloc: Allocator, user: []const u8, is_super: bool) !json.Value {
    var e: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &e, "all", .{ .bool = is_super });

    var reports: std.ArrayList(json.Value.Entry) = .empty;
    if (is_super) {
        for (rep_ids) |id| try putInt(alloc, &reports, id, true);
    } else {
        var aux = try authz.auxSession(sess, "COtherServices1");
        defer aux.deinit();
        for (rep_ids) |id| {
            const allowed = checkReport(&aux, sess, user, id) catch false;
            try putInt(alloc, &reports, id, allowed);
        }
    }
    try common.put(alloc, &e, "reports", try common.objFrom(alloc, &reports));

    // voucher_types/masters: empty = deny-all pending Collection
    // enumeration (GetVchTypesForUserRights) / no primitive exists.
    var vt: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &e, "voucher_types", try common.objFrom(alloc, &vt));
    var masters: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &e, "masters", try common.objFrom(alloc, &masters));
    try common.put(alloc, &e, "can_authorise", .{ .bool = false });
    return common.objFrom(alloc, &e);
}

/// Deny-all rights — the fail-closed fallback when resolution itself
/// is unavailable (contract §3: unknown ⇒ deny).
pub fn denyAll(alloc: Allocator) !json.Value {
    var e: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &e, "all", .{ .bool = false });
    var reports: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &e, "reports", try common.objFrom(alloc, &reports));
    var vt: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &e, "voucher_types", try common.objFrom(alloc, &vt));
    var masters: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &e, "masters", try common.objFrom(alloc, &masters));
    try common.put(alloc, &e, "can_authorise", .{ .bool = false });
    return common.objFrom(alloc, &e);
}

/// BUSY-012 enforcement map: our normalized report names -> BUSY
/// repIDs. Only PROVEN mappings ship (sparse repID space; probe §7 +
/// BUSY Functions.md): `ledger` is BUSY's Account Ledger (repID 19 —
/// also the live-granted report for user1). Unmapped names fail
/// closed for non-super users; extend via the GUI-grant assist (grant
/// the report to user1 in the BUSY user-rights screen, re-sweep
/// `CheckUserRightsForReports` — the flipped ID is the report).
pub fn repIdForName(name: []const u8) ?i64 {
    if (std.ascii.eqlIgnoreCase(name, "ledger")) return 19; // Account Ledger
    return null;
}

/// Compact per-session rights for request gating (contract §3 subset,
/// stashed at login): super flag + one bit per rep_ids entry.
pub const RightsBits = struct {
    all: bool = false,
    mask: u32 = 0,
};

/// Extract gating bits from a resolved-rights JSON value (the same
/// payload `/auth/login` and `/auth/me` return under "rights").
pub fn bitsFromJson(rights: *const json.Value) RightsBits {
    var b = RightsBits{};
    if (rights.get("all")) |v| {
        if (v.* == .bool) b.all = v.bool;
    }
    const reports = rights.get("reports") orelse return b;
    for (rep_ids, 0..) |id, i| {
        var kb: [8]u8 = undefined;
        const key = std.fmt.bufPrint(&kb, "{d}", .{id}) catch continue;
        if (reports.get(key)) |v| {
            if (v.* == .bool and v.bool) b.mask |= @as(u32, 1) << @intCast(i);
        }
    }
    return b;
}

/// May this session view the named report? Super users always; others
/// only when the report maps to a granted repID (unmapped ⇒ deny,
/// contract §3 fail-closed).
pub fn canViewReport(b: RightsBits, name: []const u8) bool {
    if (b.all) return true;
    const id = repIdForName(name) orelse return false;
    for (rep_ids, 0..) |rid, i| {
        if (rid == id) return (b.mask & (@as(u32, 1) << @intCast(i))) != 0;
    }
    return false;
}

/// One `CheckUserRightsForReports` call: true = may view report `id`.
fn checkReport(aux: *busyc.Session, sess: *busyc.Session, user: []const u8, id: i64) !bool {
    var arg: [7]json.Value = undefined;
    arg[0] = .{ .str = try aux.alloc.dupe(u8, user) };
    defer arg[0].deinit(aux.alloc);
    arg[1] = .{ .int = id };
    arg[2] = .{ .int = 0 }; // p_BranchCode (0 = default)
    arg[3] = .{ .int = 0 }; // p_VchSeriesGrpCode
    arg[4] = .{ .int = 0 }; // p_masterSeriesGrpCode
    arg[5] = .{ .str = "" }; // p_MastName
    var byref: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(aux.alloc, &byref, "$byref", .{ .str = "bstr" });
    arg[6] = try common.objFrom(aux.alloc, &byref); // p_ErrStr (out)
    if (aux.invoke("CheckUserRightsForReports", &arg)) |r| {
        var res = r;
        defer res.deinit(aux.alloc);
        return res.ret == .bool and res.ret.bool;
    } else |err| {
        sess.setErr("CheckUserRightsForReports(repID={d}) failed: {s}", .{ id, @errorName(err) });
        return err;
    }
}

fn putInt(alloc: Allocator, e: *std.ArrayList(json.Value.Entry), id: i64, allowed: bool) !void {
    var kbuf: [8]u8 = undefined;
    const key = std.fmt.bufPrint(&kbuf, "{d}", .{id}) catch unreachable;
    try common.put(alloc, e, key, .{ .bool = allowed });
}

// ---------------- tests (pure, no COM) ----------------

const testing = std.testing;

test "rep_ids fit VB6 Integer and cover the verified space" {
    for (rep_ids) |id| {
        try testing.expect(id >= -32768 and id <= 32767);
    }
    try testing.expectEqual(@as(usize, 19), rep_ids.len);
}

test "denyAll is fully closed" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const v = try denyAll(arena.allocator());
    try testing.expect(v == .obj);
    try testing.expectEqual(@as(?bool, false), v.get("all").?.bool);
    try testing.expectEqual(@as(usize, 0), v.get("reports").?.obj.len);
    try testing.expectEqual(@as(usize, 0), v.get("voucher_types").?.obj.len);
    try testing.expectEqual(@as(?bool, false), v.get("can_authorise").?.bool);
}

test "repIdForName: ledger maps to Account Ledger 19, else fail closed" {
    try testing.expectEqual(@as(?i64, 19), repIdForName("ledger"));
    try testing.expectEqual(@as(?i64, 19), repIdForName("LEDGER"));
    try testing.expect(repIdForName("day-book") == null);
    try testing.expect(repIdForName("trial-balance") == null);
    try testing.expect(repIdForName("") == null);
}

test "canViewReport gates by bits and denies unmapped reports" {
    // super: everything
    try testing.expect(canViewReport(.{ .all = true }, "day-book"));
    // user1-like bits: repID 19 granted (index of 19 in rep_ids)
    var granted = RightsBits{};
    for (rep_ids, 0..) |id, i| {
        if (id == 19) granted.mask = @as(u32, 1) << @intCast(i);
    }
    try testing.expect(canViewReport(granted, "ledger"));
    try testing.expect(!canViewReport(granted, "day-book")); // unmapped
    try testing.expect(!canViewReport(.{}, "ledger")); // no bits
}
