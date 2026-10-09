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

    // --- masters: create ---
    if (eql(u8, op_name, "create-account")) return masters.create(sess, alloc, .account, args);
    if (eql(u8, op_name, "create-item")) return masters.create(sess, alloc, .item, args);

    // --- masters: update (positional name injected by the transport) ---
    if (eql(u8, op_name, "update-account") or eql(u8, op_name, "update-item")) {
        const name = try masters.requireStr(sess, args, "name", "update requires \"name\" (the master to change)");
        const kind: masters.Kind = if (eql(u8, op_name, "update-account")) .account else .item;
        return masters.update(sess, alloc, kind, name, args);
    }

    // --- masters: delete ---
    if (eql(u8, op_name, "delete-account") or eql(u8, op_name, "delete-item")) {
        const name = try masters.requireStr(sess, args, "name", "delete requires \"name\"");
        const kind: masters.Kind = if (eql(u8, op_name, "delete-account")) .account else .item;
        return masters.delete(sess, alloc, kind, name);
    }

    // --- vouchers ---
    if (eql(u8, op_name, "post-voucher")) return vouchers.post(sess, alloc, args);
    if (eql(u8, op_name, "delete-voucher")) {
        const code = if (args.get("code")) |c| c else return badArg(sess, "delete voucher requires \"code\" (integer VchCode)");
        if (code.* != .int) return badArg(sess, "\"code\" must be an integer VchCode");
        return vouchers.delete(sess, alloc, code.int);
    }

    // --- batch is entry-shaped, never dispatched individually ---
    if (eql(u8, op_name, "batch")) return badArg(sess, "\"batch\" is not an entry op (POST /op/batch)");

    return badArg(sess, "unknown write op (supported: create-account, create-item, update-account, update-item, delete-account, delete-item, post-voucher, delete-voucher)");
}

/// True when `op_name` is a write op executable inside a batch.
pub fn isWriteOp(op_name: []const u8) bool {
    const write_ops = [_][]const u8{
        "create-account", "create-item", "update-account", "update-item",
        "delete-account", "delete-item", "post-voucher",   "delete-voucher",
    };
    for (write_ops) |w| if (eql(u8, w, op_name)) return true;
    return false;
}

// ---------------- tests (pure validation) ----------------

const testing = std.testing;

test "isWriteOp matches the catalog write set" {
    try testing.expect(isWriteOp("create-account"));
    try testing.expect(isWriteOp("post-voucher"));
    try testing.expect(!isWriteOp("list-accounts"));
    try testing.expect(!isWriteOp("batch"));
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
}
