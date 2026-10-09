//! COM orchestration shared by CLI commands and HTTP routes:
//! open a company session, serialize a session's surface to JSON text.
//!
//! Facade (issue #7, RFC docs/erp-operations-layer.md): the ERP-level
//! operations live in `ops/` beneath this barrel — normalized reads with
//! mechanical internals (constants -> SQL/XML codec -> Save*/Get*XML).
//! Raw `call`/`query` stay available as the escape hatch.
const std = @import("std");
const json = @import("../util/json.zig");
const busyc = @import("com.zig");
const registry = @import("registry.zig");

pub const masters = @import("ops/masters.zig");
pub const vouchers = @import("ops/vouchers.zig");
pub const common = @import("ops/common.zig");
pub const exec = @import("ops/exec.zig");
pub const batch = @import("ops/batch.zig");
pub const reports = @import("ops/reports.zig");
pub const catalog = @import("ops/catalog.zig");

const Allocator = std.mem.Allocator;

/// Options to open a BUSY company session (domain-level, not CLI-specific).
pub const OpenOpts = struct {
    prog_id: []const u8,
    busy: []const u8,
    data: []const u8,
    comp: ?[]const u8,
};

pub fn openSession(sess: *busyc.Session, o: OpenOpts) !void {
    try sess.create(o.prog_id);
    try openCompany(sess, o);
}

/// Open (or switch to) a company on an existing dispatch (issue #5).
/// Same logic as the body of the old openSession: OpenDB when the class
/// has it, otherwise a transient fixed-interface aux session (the company
/// state lives in the COM server for this process and outlives the opener).
pub fn openCompany(sess: *busyc.Session, o: OpenOpts) !void {
    const comp = o.comp orelse return;
    var open_args = [_]json.Value{ .{ .str = o.busy }, .{ .str = o.data }, .{ .str = comp } };

    if (sess.invoke("OpenDB", &open_args)) |r| {
        var res = r;
        defer res.deinit(sess.alloc);
        if (res.ret == .bool and !res.ret.bool) {
            sess.setErr("OpenDB rejected company '{s}' in {s}", .{ comp, o.data });
            return error.OpenDbFailed;
        }
        return;
    } else |err| {
        if (err != error.NoSuchMember) return err;
        // Services classes (CMasterServices/CTranServices/COtherServices)
        // have no OpenDB: open through a transient fixed-interface
        // session. Probe-verified (issue #7 M2): the company state lives
        // in the COM server for this process and outlives the opener.
        const fi = registry.newestFixedInterface() orelse return error.NoBusyProgId;
        var aux = try busyc.Session.init(sess.alloc);
        defer aux.deinit();
        aux.create(fi) catch |aerr| {
            sess.setErr("aux open via '{s}' failed: {s}", .{ fi, @errorName(aerr) });
            return aerr;
        };
        if (aux.invoke("OpenDB", &open_args)) |ar| {
            var ares = ar;
            defer ares.deinit(aux.alloc);
            if (ares.ret == .bool and !ares.ret.bool) {
                sess.setErr("OpenDB rejected company '{s}' in {s}", .{ comp, o.data });
                return error.OpenDbFailed;
            }
            return;
        } else |aerr| {
            sess.setErr("aux OpenDB failed: {s}", .{@errorName(aerr)});
            return aerr;
        }
    }
}

/// Close the open company on a session (issue #5, swap-based switching).
/// CloseDB is 0-param (live probed) and only exists on fixed-interface
/// classes; services classes close through a transient aux fixed interface,
/// mirroring openCompany's aux path. Errors after close are not fatal to
/// the caller — the process-global company slot may already be free.
pub fn closeCompany(sess: *busyc.Session) !void {
    var no_args = [_]json.Value{};
    if (sess.invoke("CloseDB", &no_args)) |r| {
        var res = r;
        defer res.deinit(sess.alloc);
        return;
    } else |err| {
        if (err != error.NoSuchMember) return err;
        const fi = registry.newestFixedInterface() orelse return error.NoBusyProgId;
        var aux = try busyc.Session.init(sess.alloc);
        defer aux.deinit();
        aux.create(fi) catch |aerr| {
            sess.setErr("aux close via '{s}' failed: {s}", .{ fi, @errorName(aerr) });
            return aerr;
        };
        if (aux.invoke("CloseDB", &no_args)) |ar| {
            var ares = ar;
            defer ares.deinit(aux.alloc);
            return;
        } else |aerr| {
            sess.setErr("aux CloseDB failed: {s}", .{@errorName(aerr)});
            return aerr;
        }
    }
}

/// Serialize a session's IDispatch surface to JSON text.
pub fn surfaceText(sess: *busyc.Session, alloc: Allocator, prog_id: []const u8, member_filter: ?[]const u8) ![]u8 {
    const members = try sess.surface(alloc);
    defer {
        for (members) |*m| m.deinit(alloc);
        alloc.free(members);
    }
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var w = json.Writer{ .buf = &out, .alloc = alloc };
    try w.raw("{\"prog_id\":");
    try w.str(prog_id);
    try w.raw(",\"count\":");
    {
        var b: [16]u8 = undefined;
        try w.raw(std.fmt.bufPrint(&b, "{d}", .{members.len}) catch unreachable);
    }
    try w.raw(",\"members\":[");
    var written: usize = 0;
    for (members) |m| {
        if (member_filter) |f| {
            if (!std.ascii.eqlIgnoreCase(m.name, f)) continue;
        }
        if (written != 0) try w.raw(",");
        written += 1;
        try w.raw("{\"name\":");
        try w.str(m.name);
        try w.raw(",\"kind\":");
        try w.str(m.kind);
        try w.raw(",\"nparams\":");
        {
            var b: [16]u8 = undefined;
            try w.raw(std.fmt.bufPrint(&b, "{d}", .{m.nparams}) catch unreachable);
        }
        try w.raw(",\"nopt\":");
        {
            var b: [16]u8 = undefined;
            try w.raw(std.fmt.bufPrint(&b, "{d}", .{m.nopt}) catch unreachable);
        }
        try w.raw(",\"params\":[");
        for (m.params, 0..) |p, i| {
            if (i != 0) try w.raw(",");
            try w.str(p);
        }
        try w.raw("]}");
    }
    try w.raw("]}");
    return out.toOwnedSlice(alloc);
}
