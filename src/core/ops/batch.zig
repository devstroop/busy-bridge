//! Batch posts inside a BUSY transaction (issue #7 M2):
//! `BeginTran`/`CommitTran`/`RollBackTran` live on **COtherServices** —
//! a services class with no OpenDB of its own. Probe-verified: services
//! classes share company state with any opener in the same COM process,
//! and that state outlives the opener, so the transaction session here
//! is a transient second Session (nested CoInitialize is reference-
//! counted on the same apartment thread).
const std = @import("std");
const json = @import("../../util/json.zig");
const registry = @import("../registry.zig");
const common = @import("common.zig");
const exec = @import("exec.zig");
const com = @import("../com.zig");

const Allocator = std.mem.Allocator;
const Session = com.Session;

/// `Busy2L21.CFixedInterface` -> `Busy2L21.COtherServices` (same
/// generation — both come from the registry scan).
fn tranProgId(alloc: Allocator) ![]u8 {
    const fi = registry.newestFixedInterface() orelse return error.NoBusyProgId;
    const i = std.mem.indexOf(u8, fi, "CFixedInterface") orelse return error.NoBusyProgId;
    return std.fmt.allocPrint(alloc, "{s}COtherServices", .{fi[0..i]});
}

/// Validate one entry's shape (object + string `op` + batchable write
/// op + `args` present) WITHOUT touching COM or the registry — input
/// errors must surface even on machines without BUSY installed (CI
/// runners); asserted by the "before touching COM" unit test and the
/// same pattern as cmdQuery's refuse-before-COM contract.
fn validateEntry(entry: *const json.Value, i: usize, sess: *Session) !void {
    if (entry.* != .obj) {
        sess.setErr("batch entry [{d}] must be an object {{\"op\":...,\"args\":{{...}}}}", .{i});
        return error.BadArgs;
    }
    const op_v = entry.get("op") orelse {
        sess.setErr("batch entry [{d}] missing \"op\"", .{i});
        return error.BadArgs;
    };
    if (op_v.* != .str) {
        sess.setErr("batch entry [{d}]: \"op\" must be a string", .{i});
        return error.BadArgs;
    }
    if (!exec.isWriteOp(op_v.str)) {
        sess.setErr("batch entry [{d}]: '{s}' is not a batchable write op", .{ i, op_v.str });
        return error.BadArgs;
    }
    if (entry.get("args") == null) {
        sess.setErr("batch entry [{d}] missing \"args\"", .{i});
        return error.BadArgs;
    }
}

/// Run write entries `[{"op":"...","args":{...}}, ...]` atomically.
/// One failure rolls the whole batch back and reports which entry broke
/// (`code:"batch_rolled_back"` with the underlying message).
pub fn run(sess: *Session, alloc: Allocator, entries: *const json.Value) !json.Value {
    if (entries.* != .arr or entries.arr.len == 0) {
        sess.setErr("batch requires a non-empty array: [{{\"op\":\"create-account\",\"args\":{{...}}}}, ...]", .{});
        return error.BadArgs;
    }
    // Shape-validate every entry BEFORE the registry lookup / COM session
    // (issue CI fix 2026-10-09: on a no-BUSY machine the lookup used to
    // fail with NoBusyProgId before BadArgs could surface).
    for (entries.arr, 0..) |*entry, i| try validateEntry(entry, i, sess);

    const prog = try tranProgId(alloc);
    defer alloc.free(prog);
    var ts = try Session.init(sess.alloc);
    defer ts.deinit();
    ts.create(prog) catch |err| {
        sess.setErr("transaction session ({s}) failed: {s}", .{ prog, @errorName(err) });
        return err;
    };
    var b = try ts.invoke("BeginTran", &.{});
    defer b.deinit(ts.alloc);

    var results: std.ArrayList(json.Value) = .empty;
    defer {
        for (results.items) |*v| v.deinit(alloc);
        results.deinit(alloc);
    }

    for (entries.arr, 0..) |*entry, i| {
        // pre-pass guaranteed validity; re-assert so the unwraps below are
        // sound even if the pre-pass is ever bypassed
        try validateEntry(entry, i, sess);
        const op_str = entry.get("op").?.str;
        const args = entry.get("args").?;

        const res = exec.run(sess, alloc, op_str, args) catch {
            // capture the failing message BEFORE rolling back (the
            // session error buffer still holds it at this point)
            var fail_buf: [700]u8 = undefined;
            const fail_msg = std.fmt.bufPrint(&fail_buf, "op[{d}] '{s}': {s}", .{ i, op_str, sess.lastError() }) catch "batch entry failed";
            if (ts.invoke("RollBackTran", &.{})) |vr| {
                var v = vr;
                v.deinit(ts.alloc);
            } else |_| {}
            sess.setErr("{s} - batch rolled back", .{fail_msg});
            return error.BatchRolledBack;
        };
        try results.append(alloc, res);
    }

    var c = try ts.invoke("CommitTran", &.{});
    defer c.deinit(ts.alloc);

    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "committed", .{ .bool = true });
    try common.put(alloc, &out, "count", .{ .int = @intCast(results.items.len) });
    try common.put(alloc, &out, "results", .{ .arr = try results.toOwnedSlice(alloc) });
    return common.objFrom(alloc, &out);
}

// ---------------- tests (pure) ----------------

const testing = std.testing;

test "tranProgId derives COtherServices from the fixed interface" {
    const a = testing.allocator;
    if (registry.newestFixedInterface()) |fi| {
        try testing.expect(std.mem.indexOf(u8, fi, "CFixedInterface") != null);
        const p = try tranProgId(a);
        defer a.free(p);
        try testing.expect(std.mem.indexOf(u8, p, "COtherServices") != null);
        try testing.expect(std.mem.indexOf(u8, p, "CFixedInterface") == null);
        // same generation prefix (e.g. Busy2L21.)
        try testing.expect(std.mem.indexOf(u8, p, fi[0 .. fi.len - "CFixedInterface".len]) == 0);
    }
}

test "run validates batch entry shapes before touching COM" {
    const a = testing.allocator;
    var sess = try Session.init(a);
    defer sess.deinit();

    var empty = try json.parse(a, "[]");
    defer empty.deinit(a);
    try testing.expectError(error.BadArgs, run(&sess, a, &empty));

    var reads = try json.parse(a, "[{\"op\":\"list-accounts\",\"args\":{}}]");
    defer reads.deinit(a);
    try testing.expectError(error.BadArgs, run(&sess, a, &reads));
    try testing.expect(std.mem.indexOf(u8, sess.lastError(), "batchable write op") != null);
}
