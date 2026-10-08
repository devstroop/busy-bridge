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

pub const masters = @import("ops/masters.zig");
pub const vouchers = @import("ops/vouchers.zig");
pub const common = @import("ops/common.zig");
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
    if (o.comp) |c| {
        var open_args = [_]json.Value{ .{ .str = o.busy }, .{ .str = o.data }, .{ .str = c } };
        var r = try sess.invoke("OpenDB", &open_args);
        defer r.deinit(sess.alloc);
        switch (r.ret) {
            .bool => |b| if (!b) {
                sess.setErr("OpenDB rejected company '{s}' in {s}", .{ c, o.data });
                return error.OpenDbFailed;
            },
            else => {},
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
