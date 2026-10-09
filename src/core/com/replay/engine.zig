//! Replay: host-agnostic Session-shaped reader over JSONL transcripts.
//!
//! Transcript format (one JSON object per line; see testdata/golden.jsonl):
//!   header: {"format":"busy-bridge-transcript/1","recorded_at":<epoch ms>,
//!            "busy_version":"Rel 14","prog_id":"...","synthetic":bool}
//!   invoke: {"seq":N,"op":"invoke","method":"OpenDB","args":[...],
//!            "ok":true,"ret":<json>,"outs":[<json>...]}
//!           {"seq":N,"op":"invoke","method":"M","args":[...],
//!            "ok":false,"error":"NoSuchMember","message":"..."}
//!   query:  {"seq":N,"op":"query","sql":"SELECT ...",
//!            "ok":true,"rows":[<json>...]}
//!           {"seq":N,"op":"query","sql":"...",
//!            "ok":false,"error":"NoRecordset","message":"..."}
//!
//! Matching is strict and sequential: the next entry must name the same op
//! with an equal method+args (object keys order-insensitive) or the same
//! SQL; anything else is error.StaleTranscript — a changed call sequence,
//! never a silent pass. Recorded errors map back to the same Zig error set
//! and message the live Session would produce. Returned values are owned
//! copies, safe to deinit like live results.
const std = @import("std");
const json = @import("../../../util/json.zig");
const result_mod = @import("../result.zig");

const Allocator = std.mem.Allocator;

pub const transcript_format = "busy-bridge-transcript/1";

pub const Replay = struct {
    alloc: Allocator,
    lines: []json.Value = &.{},
    pos: usize = 1, // lines[0] is the header
    busy_version: []const u8 = "",
    prog_id: []const u8 = "",
    synthetic: bool = false,
    stale_warn: bool = false,
    err_buf: [1024]u8 = undefined,
    err_len: usize = 0,

    /// Parse every line up front. `expected_busy_version`, when given,
    /// arms `stale_warn` instead of failing on recording drift (the 009
    /// staleness guard: warn, keep running).
    pub fn init(alloc: Allocator, text: []const u8, expected_busy_version: ?[]const u8) !Replay {
        var lines: std.ArrayList(json.Value) = .empty;
        errdefer {
            for (lines.items) |*l| l.deinit(alloc);
            lines.deinit(alloc);
        }
        var it = std.mem.splitScalar(u8, text, '\n');
        while (it.next()) |raw| {
            const t = std.mem.trim(u8, raw, " \t\r");
            if (t.len == 0) continue;
            var v = try json.parse(alloc, t);
            lines.append(alloc, v) catch {
                v.deinit(alloc);
                return error.OutOfMemory;
            };
        }
        if (lines.items.len == 0) return error.CorruptTranscript;
        const fmt = strField(&lines.items[0], "format") orelse return error.CorruptTranscript;
        if (!std.mem.eql(u8, fmt, transcript_format)) return error.CorruptTranscript;
        var r = Replay{ .alloc = alloc, .lines = try lines.toOwnedSlice(alloc) };
        lines.deinit(alloc);
        // Re-acquire after toOwnedSlice: it may move the buffer, so no
        // pointer into lines.items may survive across it.
        const head = &r.lines[0];
        r.busy_version = strField(head, "busy_version") orelse "";
        r.prog_id = strField(head, "prog_id") orelse "";
        r.synthetic = boolField(head, "synthetic") orelse false;
        if (expected_busy_version) |want| {
            if (!std.mem.eql(u8, want, r.busy_version)) r.stale_warn = true;
        }
        return r;
    }

    pub fn deinit(self: *Replay) void {
        for (self.lines) |*l| l.deinit(self.alloc);
        self.alloc.free(self.lines);
        self.* = undefined;
    }

    /// Entries after the header.
    pub fn count(self: *const Replay) usize {
        return self.lines.len -| 1;
    }

    pub fn setErr(self: *Replay, comptime fmt: []const u8, args: anytype) void {
        const msg = std.fmt.bufPrint(&self.err_buf, fmt, args) catch return;
        self.err_len = msg.len;
    }

    pub fn lastError(self: *const Replay) []const u8 {
        return self.err_buf[0..self.err_len];
    }

    fn next(self: *Replay) ?*json.Value {
        if (self.pos >= self.lines.len) return null;
        return &self.lines[self.pos];
    }

    pub fn invoke(self: *Replay, method: []const u8, args: []const json.Value) !result_mod.CallResult {
        const line = self.next() orelse return error.StaleTranscript;
        if (!isOp(line, "invoke")) return error.StaleTranscript;
        const want_method = strField(line, "method") orelse return error.CorruptTranscript;
        if (!std.mem.eql(u8, want_method, method)) return error.StaleTranscript;
        const want_args = line.get("args") orelse return error.CorruptTranscript;
        var actual: json.Value = .{ .arr = @constCast(args) };
        if (!jsonEqual(want_args, &actual)) return error.StaleTranscript;
        self.pos += 1;
        if (!(boolField(line, "ok") orelse return error.CorruptTranscript)) {
            const name = strField(line, "error") orelse return error.CorruptTranscript;
            self.setErr("{s}", .{strField(line, "message") orelse ""});
            return mapError(name);
        }
        const ret_src = line.get("ret") orelse return error.CorruptTranscript;
        const outs_src = line.get("outs") orelse return error.CorruptTranscript;
        if (outs_src.* != .arr) return error.CorruptTranscript;
        var ret = try dupValue(self.alloc, ret_src);
        errdefer ret.deinit(self.alloc);
        var outs = try self.alloc.alloc(json.Value, outs_src.arr.len);
        errdefer {
            for (outs) |*o| o.deinit(self.alloc);
            self.alloc.free(outs);
        }
        for (outs_src.arr, 0..) |*src, i| outs[i] = try dupValue(self.alloc, src);
        return .{ .ret = ret, .outs = outs };
    }

    pub fn queryToJson(self: *Replay, sql: []const u8) !json.Value {
        const line = self.next() orelse return error.StaleTranscript;
        if (!isOp(line, "query")) return error.StaleTranscript;
        const want_sql = strField(line, "sql") orelse return error.CorruptTranscript;
        if (!std.mem.eql(u8, want_sql, sql)) return error.StaleTranscript;
        self.pos += 1;
        if (!(boolField(line, "ok") orelse return error.CorruptTranscript)) {
            const name = strField(line, "error") orelse return error.CorruptTranscript;
            self.setErr("{s}", .{strField(line, "message") orelse ""});
            return mapError(name);
        }
        const rows_src = line.get("rows") orelse return error.CorruptTranscript;
        if (rows_src.* != .arr) return error.CorruptTranscript;
        return dupValue(self.alloc, rows_src);
    }
};

fn isOp(line: *const json.Value, want: []const u8) bool {
    const op = strField(line, "op") orelse return false;
    return std.mem.eql(u8, op, want);
}

fn strField(line: *const json.Value, key: []const u8) ?[]const u8 {
    const v = line.get(key) orelse return null;
    if (v.* != .str) return null;
    return v.str;
}

fn boolField(line: *const json.Value, key: []const u8) ?bool {
    const v = line.get(key) orelse return null;
    if (v.* != .bool) return null;
    return v.bool;
}

/// Order-insensitive object compare (arrays stay ordered): recorded args
/// match regardless of key construction order on either side.
fn jsonEqual(a: *const json.Value, b: *const json.Value) bool {
    if (std.meta.activeTag(a.*) != std.meta.activeTag(b.*)) return false;
    return switch (a.*) {
        .null => true,
        .bool => |x| x == b.bool,
        .int => |x| x == b.int,
        .float => |x| x == b.float,
        .str => |x| std.mem.eql(u8, x, b.str),
        .arr => |x| blk: {
            if (x.len != b.arr.len) break :blk false;
            for (x, b.arr) |*va, *vb| if (!jsonEqual(va, vb)) break :blk false;
            break :blk true;
        },
        .obj => |x| blk: {
            if (x.len != b.obj.len) break :blk false;
            for (x) |*e| {
                const o = b.get(e.key) orelse break :blk false;
                if (!jsonEqual(&e.val, o)) break :blk false;
            }
            break :blk true;
        },
    };
}

/// Owned copy through text: no shared or borrowed structure with the
/// transcript, so results deinit exactly like live ones.
fn dupValue(alloc: Allocator, v: *const json.Value) !json.Value {
    var tmp: std.ArrayList(u8) = .empty;
    defer tmp.deinit(alloc);
    var w = json.Writer{ .buf = &tmp, .alloc = alloc };
    try json.stringify(v, &w);
    return json.parse(alloc, tmp.items);
}

/// Recorded error names back to the Zig sets the live Session returns.
/// Anything unrecognized is ReplayUnknownError, never a guess.
fn mapError(name: []const u8) anyerror {
    const table = std.StaticStringMap(anyerror).initComptime(.{
        .{ "NoDispatch", error.NoDispatch },
        .{ "NoSuchMember", error.NoSuchMember },
        .{ "BadArgs", error.BadArgs },
        .{ "InvokeFailed", error.InvokeFailed },
        .{ "QueryFailed", error.QueryFailed },
        .{ "NoRecordset", error.NoRecordset },
        .{ "NoFields", error.NoFields },
        .{ "TooManyArgs", error.TooManyArgs },
        .{ "ComInit", error.ComInit },
        .{ "Clsid", error.Clsid },
        .{ "Create", error.Create },
        .{ "BadGuid", error.BadGuid },
        .{ "OpenDbFailed", error.OpenDbFailed },
        .{ "NotFound", error.NotFound },
        .{ "BusyRejected", error.BusyRejected },
        .{ "UnexpectedRows", error.UnexpectedRows },
    });
    return table.get(name) orelse error.ReplayUnknownError;
}
