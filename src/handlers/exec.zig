//! The operations dispatcher (issue #7 M2): one JSON-args entry point
//! shared by single-op CLI/HTTP calls AND batch transactions. Validates
//! args with precise session-level messages (-> bad_args) and returns
//! the op's result object. Write ops only — reads keep their typed
//! signatures in masters.zig / vouchers.zig.
const std = @import("std");
const json = @import("../util/json.zig");
const common = @import("common.zig");
const masters = @import("masters.zig");
const vouchers = @import("vouchers.zig");
const Session = @import("../core/com.zig").Session;

const Allocator = std.mem.Allocator;
const eql = std.mem.eql;

fn badArg(sess: *Session, msg: []const u8) error{BadArgs} {
    sess.setErr("{s}", .{msg});
    return error.BadArgs;
}

/// Dispatch one operation by catalog name.
pub fn run(sess: *Session, alloc: Allocator, op_name: []const u8, args: *const json.Value) !json.Value {
    if (args.* != .obj) return badArg(sess, "op args must be a JSON object");

    // --- masters: create/update/delete for every kind in the registry
    // (WP2). Read-only kinds resolve here too, so their precise handler
    // message ("writes … not wired yet") beats the generic fallthrough.
    if (std.mem.startsWith(u8, op_name, "create-")) {
        if (masters.kindBySing(op_name["create-".len..])) |kind|
            return masters.create(sess, alloc, kind, args);
    }
    if (std.mem.startsWith(u8, op_name, "update-")) {
        if (masters.kindBySing(op_name["update-".len..])) |kind|
            return masters.update(sess, alloc, kind, args);
    }
    if (std.mem.startsWith(u8, op_name, "delete-")) {
        if (masters.kindBySing(op_name["delete-".len..])) |kind|
            return masters.delete(sess, alloc, kind, args);
    }

    // --- vouchers (their kind word is not a master kind, so the
    // delete- prefix above never captures them) ---
    if (eql(u8, op_name, "post-voucher")) return vouchers.post(sess, alloc, args);
    if (eql(u8, op_name, "delete-voucher")) {
        const code = if (args.get("code")) |c| c else return badArg(sess, "delete voucher requires \"code\" (integer VchCode)");
        if (code.* != .int) return badArg(sess, "\"code\" must be an integer VchCode");
        return vouchers.delete(sess, alloc, code.int);
    }

    // --- batch is entry-shaped, never dispatched individually ---
    if (eql(u8, op_name, "batch")) return badArg(sess, "\"batch\" is not an entry op (POST /op/batch)");

    return badArg(sess, "unknown write op (see GET /op or busy-bridge op catalog for supported names)");
}

/// True when `op_name` is a write op executable inside a batch: the two
/// voucher ops plus `create|update|delete-<kind>` for any registry kind
/// (read-only kinds pass here on purpose — the handler answers its
/// precise fail-closed message and the batch rolls back with context).
pub fn isWriteOp(op_name: []const u8) bool {
    if (eql(u8, op_name, "post-voucher") or eql(u8, op_name, "delete-voucher")) return true;
    const prefixes = [_][]const u8{ "create-", "update-", "delete-" };
    for (prefixes) |p| {
        if (std.mem.startsWith(u8, op_name, p))
            return masters.kindBySing(op_name[p.len..]) != null;
    }
    return false;
}

// ---------------- tests (pure validation) ----------------

const testing = std.testing;

test "isWriteOp matches the catalog write set" {
    try testing.expect(isWriteOp("create-account"));
    try testing.expect(isWriteOp("post-voucher"));
    try testing.expect(!isWriteOp("list-accounts"));
    try testing.expect(!isWriteOp("batch"));
    // WP2: registry-driven write names (probe-wired kinds included)
    try testing.expect(isWriteOp("create-unit"));
    try testing.expect(isWriteOp("update-sale-type"));
    try testing.expect(isWriteOp("delete-tax-category"));
    // read-only kinds pass the gate so the handler can answer precisely
    try testing.expect(isWriteOp("create-unit-conversion"));
    try testing.expect(!isWriteOp("create-unicorns"));
    try testing.expect(!isWriteOp("get-unit"));
}

test "run validates args shape with session messages" {
    const a = testing.allocator;
    var sess = try Session.init(a);
    defer sess.deinit();

    var obj = try json.parse(a, "{}");
    defer obj.deinit(a);
    // unknown op
    try testing.expectError(error.BadArgs, run(&sess, a, "frobnicate", &obj));
    try testing.expect(std.mem.indexOf(u8, sess.lastError(), "unknown write op") != null);
    // missing name on update
    try testing.expectError(error.BadArgs, run(&sess, a, "update-account", &obj));
    try testing.expect(std.mem.indexOf(u8, sess.lastError(), "\"name\"") != null);
    // non-object args
    var arr = try json.parse(a, "[]");
    defer arr.deinit(a);
    try testing.expectError(error.BadArgs, run(&sess, a, "delete-item", &arr));
    // WP2 gates answer before any COM call:
    // read-only kind resolves to its precise message, not the fallthrough
    try testing.expectError(error.BadArgs, run(&sess, a, "create-unit-conversion", &obj));
    try testing.expect(std.mem.indexOf(u8, sess.lastError(), "not wired yet") != null);
    try testing.expect(std.mem.indexOf(u8, sess.lastError(), "unknown write op") == null);
    try testing.expectError(error.BadArgs, run(&sess, a, "update-bom", &obj));
    try testing.expect(std.mem.indexOf(u8, sess.lastError(), "not wired yet") != null);
    // delete gated for a kind whose COM delete is unreliable
    var nm = try json.parse(a, "{\"name\":\"X\"}");
    defer nm.deinit(a);
    try testing.expectError(error.BadArgs, run(&sess, a, "delete-unit", &nm));
    try testing.expect(std.mem.indexOf(u8, sess.lastError(), "COM delete") != null);
    // parent required only for account (needs_parent kinds)
    try testing.expectError(error.BadArgs, run(&sess, a, "create-account", &nm));
    try testing.expect(std.mem.indexOf(u8, sess.lastError(), "parent") != null);
}
