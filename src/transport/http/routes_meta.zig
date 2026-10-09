//! Meta route group (issue #11 phase 5): GET /health, /surface, /classes,
//! /info, /constants — capability/identity endpoints that touch the
//! registry or static tables. Returns null → caller tries the next group.
const std = @import("std");
const json = @import("../../util/json.zig");
const ops = @import("../../core/ops.zig");
const registry = @import("../../core/registry.zig");
const cli_mod = @import("../cli.zig");
const format = @import("../format.zig");
const envelope = @import("../envelope.zig");
const sh = @import("shared.zig");

const Allocator = std.mem.Allocator;
const Format = format.Format;
const ConnCtx = sh.ConnCtx;
const Route = sh.Route;

const eql = @import("../../util/helpers.zig").eql;

pub fn routeMeta(
    ctx: ConnCtx,
    ralloc: Allocator,
    fmt: Format,
    verb: []const u8,
    path: []const u8,
    query: []const u8,
) !?Route {
    const jct = format.ct_json;
    const xct = format.ct_xml;

    if (eql(verb, "GET") and eql(path, "/health")) {
        if (fmt == .xml)
            return .{ .status = "200 OK", .content_type = xct, .payload = try format.healthXml(ralloc) };
        return .{ .status = "200 OK", .content_type = jct, .payload = try envelope.okWrap(ralloc, "status", &.{ .str = "up" }) };
    }

    if (eql(verb, "GET") and eql(path, "/surface")) {
        const filter = try sh.qparam(ralloc, query, "member");
        if (fmt == .xml) {
            const members = try ctx.sess.surface(ralloc);
            return .{
                .status = "200 OK",
                .content_type = xct,
                .payload = try format.surfaceXml(ralloc, ctx.prog_id, members, filter),
            };
        }
        return .{
            .status = "200 OK",
            .content_type = jct,
            .payload = try ops.surfaceText(ctx.sess, ralloc, ctx.prog_id, filter),
        };
    }

    if (eql(verb, "GET") and eql(path, "/classes")) {
        const classes = try registry.listBusyClasses(ralloc);
        if (fmt == .xml)
            return .{ .status = "200 OK", .content_type = xct, .payload = try format.classesXml(ralloc, classes) };
        var out: std.ArrayList(u8) = .empty;
        var w = json.Writer{ .buf = &out, .alloc = ralloc };
        try w.raw("{\"ok\":true,\"classes\":[");
        for (classes, 0..) |c, i| {
            if (i != 0) try w.raw(",");
            try w.str(c);
        }
        try w.raw("]}");
        return .{ .status = "200 OK", .content_type = jct, .payload = try out.toOwnedSlice(ralloc) };
    }

    if (eql(verb, "GET") and eql(path, "/info")) {
        const active = ctx.sw.current orelse ctx.sw.opts.comp;
        if (fmt == .xml)
            return .{ .status = "200 OK", .content_type = xct, .payload = try format.infoXml(ralloc, cli_mod.VERSION, ctx.prog_id, active, ctx.sw.switches) };
        return .{ .status = "200 OK", .content_type = jct, .payload = try format.infoJson(ralloc, cli_mod.VERSION, ctx.prog_id, active, ctx.sw.switches) };
    }

    if (eql(verb, "GET") and eql(path, "/constants")) {
        if (fmt == .xml)
            return .{ .status = "200 OK", .content_type = xct, .payload = try format.constantsXml(ralloc) };
        return .{ .status = "200 OK", .content_type = jct, .payload = try format.constantsJson(ralloc) };
    }

    return null;
}
