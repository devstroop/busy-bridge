//! Recorder (issue 009): wraps a live Session and captures invoke /
//! query traffic as JSONL transcripts for `replay/`.
//!
//! Golden flows are read-only, so recording is safe to run against DEMO
//! any time: `busy-bridge record --comp COMP0001 --out transcript.jsonl`.
//! The two forced error paths (bogus member, bogus table) record whatever
//! BUSY actually returns — faithful by construction. Regenerate after
//! every BUSY upgrade; the replay staleness guard tracks busy_version.
const std = @import("std");
const json = @import("../../util/json.zig");
const Session = @import("session.zig").Session;
const invoke_mod = @import("invoke.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;

pub const Recorder = struct {
    sess: *Session,
    alloc: Allocator,
    out: std.ArrayList(u8) = .empty,
    seq: usize = 0,

    pub fn deinit(self: *Recorder) void {
        self.out.deinit(self.alloc);
    }

    pub fn header(self: *Recorder, prog_id: []const u8, recorded_at_ms: i64) !void {
        var w = json.Writer{ .buf = &self.out, .alloc = self.alloc };
        try w.raw("{\"format\":\"busy-bridge-transcript/1\",\"recorded_at\":");
        {
            var b: [24]u8 = undefined;
            try w.raw(try std.fmt.bufPrint(&b, "{d}", .{recorded_at_ms}));
        }
        try w.raw(",\"busy_version\":\"Rel 14\",\"prog_id\":");
        try w.str(prog_id);
        try w.raw(",\"synthetic\":false}\n");
    }

    fn argsJson(self: *Recorder, args: []const json.Value) ![]const u8 {
        var tmp: std.ArrayList(u8) = .empty;
        defer tmp.deinit(self.alloc);
        var w = json.Writer{ .buf = &tmp, .alloc = self.alloc };
        try w.raw("[");
        for (args, 0..) |*a, i| {
            if (i != 0) try w.raw(",");
            try json.stringify(a, &w);
        }
        try w.raw("]");
        return tmp.toOwnedSlice(self.alloc);
    }

    fn valueJson(self: *Recorder, v: *const json.Value) ![]const u8 {
        var tmp: std.ArrayList(u8) = .empty;
        defer tmp.deinit(self.alloc);
        var w = json.Writer{ .buf = &tmp, .alloc = self.alloc };
        try json.stringify(v, &w);
        return tmp.toOwnedSlice(self.alloc);
    }

    /// Invoke through the wrapped session, capturing result or error.
    /// Errors are recorded AND returned — the golden script continues.
    pub fn recordInvoke(self: *Recorder, method: []const u8, args: []const json.Value) !json.Value {
        return self.recordInvokeOn(self.sess, method, args, .{});
    }

    /// Same, with invoke options (issue #9 — enumerated Collection
    /// returns: the recorded entry notes `"enumerate_ret":true` so a
    /// transcript diff shows the shape flag explicitly).
    pub fn recordInvokeEx(self: *Recorder, method: []const u8, args: []const json.Value, opts: invoke_mod.InvokeOpts) !json.Value {
        return self.recordInvokeOn(self.sess, method, args, opts);
    }

    /// Same, against an explicit session (multi-session transcripts —
    /// the secondary COtherServices session in the golden battery, issue
    /// #9). One sequential stream regardless of the underlying session.
    pub fn recordInvokeOn(self: *Recorder, sess: *Session, method: []const u8, args: []const json.Value, opts: invoke_mod.InvokeOpts) !json.Value {
        self.seq += 1;
        const arg_text = try self.argsJson(args);
        defer self.alloc.free(arg_text);
        const opts_text = if (opts.enumerate_ret) ",\"enumerate_ret\":true" else "";
        var w = json.Writer{ .buf = &self.out, .alloc = self.alloc };
        if (sess.invokeEx(method, args, opts)) |r| {
            var res = r;
            defer res.deinit(sess.alloc);
            const ret_text = try self.valueJson(&res.ret);
            defer self.alloc.free(ret_text);
            try w.raw("{\"seq\":");
            {
                var sb: [24]u8 = undefined;
                try w.raw(std.fmt.bufPrint(&sb, "{d}", .{self.seq}) catch unreachable);
            }
            try w.raw(",\"op\":\"invoke\",\"method\":");
            try w.str(method);
            try w.raw(",\"args\":");
            try w.raw(arg_text);
            try w.raw(opts_text);
            try w.raw(",\"ok\":true,\"ret\":");
            try w.raw(ret_text);
            try w.raw(",\"outs\":[");
            for (res.outs, 0..) |*o, i| {
                if (i != 0) try w.raw(",");
                const t = try self.valueJson(o);
                defer self.alloc.free(t);
                try w.raw(t);
            }
            try w.raw("]}\n");
            // Hand ownership back: re-parse what we just wrote.
            var back = try json.parse(self.alloc, ret_text);
            errdefer back.deinit(self.alloc);
            return back;
        } else |err| {
            try w.raw("{\"seq\":");
            {
                var sb: [24]u8 = undefined;
                try w.raw(std.fmt.bufPrint(&sb, "{d}", .{self.seq}) catch unreachable);
            }
            try w.raw(",\"op\":\"invoke\",\"method\":");
            try w.str(method);
            try w.raw(",\"args\":");
            try w.raw(arg_text);
            try w.raw(opts_text);
            try w.raw(",\"ok\":false,\"error\":\"");
            try w.raw(@errorName(err));
            try w.raw("\",\"message\":");
            try w.str(sess.lastError());
            try w.raw("}\n");
            return err;
        }
    }

    /// Query through the live session, capturing rows or error.
    pub fn recordQuery(self: *Recorder, sql: []const u8) !json.Value {
        self.seq += 1;
        var w = json.Writer{ .buf = &self.out, .alloc = self.alloc };
        if (self.sess.queryToJson(sql)) |r| {
            var rows = r;
            defer rows.deinit(self.sess.alloc);
            const rows_text = try self.valueJson(&rows);
            defer self.alloc.free(rows_text);
            try w.raw("{\"seq\":");
            {
                var sb: [24]u8 = undefined;
                try w.raw(std.fmt.bufPrint(&sb, "{d}", .{self.seq}) catch unreachable);
            }
            try w.raw(",\"op\":\"query\",\"sql\":");
            try w.str(sql);
            try w.raw(",\"ok\":true,\"rows\":");
            try w.raw(rows_text);
            try w.raw("}\n");
            var back = try json.parse(self.alloc, rows_text);
            errdefer back.deinit(self.alloc);
            return back;
        } else |err| {
            try w.raw("{\"seq\":");
            {
                var sb: [24]u8 = undefined;
                try w.raw(std.fmt.bufPrint(&sb, "{d}", .{self.seq}) catch unreachable);
            }
            try w.raw(",\"op\":\"query\",\"sql\":");
            try w.str(sql);
            try w.raw(",\"ok\":false,\"error\":\"");
            try w.raw(@errorName(err));
            try w.raw("\",\"message\":");
            try w.str(self.sess.lastError());
            try w.raw("}\n");
            return err;
        }
    }

    pub fn writeFile(self: *Recorder, io: std.Io, path: []const u8) !void {
        try Io.Dir.cwd().writeFile(io, .{ .sub_path = path, .data = self.out.items });
    }
};
