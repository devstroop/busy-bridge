//! Auth primitives (BUSY-011; contract: docs/auth-contract.md §2).
//!
//! Login path over probe-verified COM (report §4–§6): all three legs
//! run against the *main* session's already-open company — the
//! company state is process-global in the COM server, so transient
//! auxiliary dispatches of sibling classes answer without their own
//! OpenDB (same mechanism as handlers.openCompany's aux fallback).
//!
//! - `loginRequired`  — `CheckIfLoginDetRequired` (COtherServices1)
//! - `validatePassword` — `ValidUserPassword` (CFixedInterface, the
//!   main session's own class) — the verified regular-user credential
//!   check; never `CheckIfLoginDetRequiredFromDatabase` (UI trap).
//! - `configPayload` — `GetCompConfigJSON` (CFixedInterface1)
//!   (probe §1.5: 16KB JSON string: CompName/BegFY/CurFY/…).
const std = @import("std");
const json = @import("../util/json.zig");
const busyc = @import("../core/com.zig");
const registry = @import("../core/registry.zig");

const Allocator = std.mem.Allocator;

/// Does `user` require a login at all? Probe-verified on
/// COtherServices1: true for configured users (admin, user1) AND for
/// unknown names — callers must not branch on the unknown-user case
/// (no enumeration; contract §4). Requires the company open.
pub fn loginRequired(sess: *busyc.Session, user: []const u8) !bool {
    var aux = try auxSession(sess, "COtherServices1");
    defer aux.deinit();
    var arg: [1]json.Value = undefined;
    arg[0] = .{ .str = try aux.alloc.dupe(u8, user) };
    defer arg[0].deinit(aux.alloc);
    if (aux.invoke("CheckIfLoginDetRequired", &arg)) |r| {
        var res = r;
        defer res.deinit(aux.alloc);
        return res.ret == .bool and res.ret.bool;
    } else |err| {
        sess.setErr("CheckIfLoginDetRequired via COtherServices1 failed: {s}", .{@errorName(err)});
        return err;
    }
}

/// THE regular-user credential check (probe §6): `ValidUserPassword`
/// lives on CFixedInterface itself — the main session's class, no aux
/// needed. Plain 2-string -> bool; false covers wrong password AND
/// unknown users (indistinguishable by design).
pub fn validatePassword(sess: *busyc.Session, user: []const u8, password: []const u8) !bool {
    var arg: [2]json.Value = undefined;
    arg[0] = .{ .str = try sess.alloc.dupe(u8, user) };
    defer arg[0].deinit(sess.alloc);
    arg[1] = .{ .str = try sess.alloc.dupe(u8, password) };
    defer arg[1].deinit(sess.alloc);
    const r = try sess.invoke("ValidUserPassword", &arg);
    var res = r;
    defer res.deinit(sess.alloc);
    return res.ret == .bool and res.ret.bool;
}

/// Company config payload for the login response (probe §1.5):
/// `GetCompConfigJSON(skipBranch=false, fy, multiFY=false)` on
/// CFixedInterface1 returns a JSON *string* — parsed into a tree here
/// so the envelope embeds it natively.
pub fn configPayload(sess: *busyc.Session, alloc: Allocator, fy: i64) !json.Value {
    var aux = try auxSession(sess, "CFixedInterface1");
    defer aux.deinit();
    var arg: [3]json.Value = undefined;
    arg[0] = .{ .bool = false };
    if (fy >= std.math.minInt(i32) and fy <= std.math.maxInt(i32)) {
        arg[1] = .{ .int = fy };
    } else {
        arg[1] = .{ .int = 0 };
    }
    arg[2] = .{ .bool = false };
    const r = try aux.invoke("GetCompConfigJSON", &arg);
    var res = r;
    defer res.deinit(aux.alloc);
    if (res.ret != .str) {
        sess.setErr("GetCompConfigJSON returned {t}, expected JSON string", .{res.ret});
        return error.BusyRejected;
    }
    // Config strings are BUSY's own JSON — parse into an arena-owned
    // tree the caller embeds (and owns via its arena).
    const parsed = json.parse(alloc, res.ret.str) catch |err| {
        sess.setErr("GetCompConfigJSON payload is not parseable JSON: {s}", .{@errorName(err)});
        return err;
    };
    return parsed; // arena-owned by the caller's allocator
}

/// Transient aux dispatch of the newest registered class with the
/// given suffix — no OpenDB (company state is process-global; probe-
/// verified via the openCompany aux fallback). Error text funnels into
/// the main session for the wire envelope. Shared with `rights.zig`.
pub fn auxSession(sess: *busyc.Session, suffix: []const u8) !busyc.Session {
    const prog_id = registry.newestProgId(suffix) orelse {
        sess.setErr("no registered Busy2L*.{s} - is this BUSY version missing the class?", .{suffix});
        return error.NoBusyProgId;
    };
    var aux = try busyc.Session.init(sess.alloc);
    errdefer aux.deinit();
    aux.create(prog_id) catch |err| {
        sess.setErr("aux create '{s}' failed: {s}", .{ prog_id, @errorName(err) });
        return err;
    };
    return aux;
}
