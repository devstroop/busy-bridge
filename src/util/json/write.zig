//! JSON serialization: streaming writer over a byte buffer + Value stringify.
const std = @import("std");
const Value = @import("value.zig").Value;

pub const Writer = struct {
    buf: *std.ArrayList(u8),
    alloc: std.mem.Allocator,
    depth: u32 = 0,

    pub fn raw(self: *Writer, s: []const u8) !void {
        try self.buf.appendSlice(self.alloc, s);
    }

    pub fn str(self: *Writer, s: []const u8) !void {
        try self.buf.append(self.alloc, '"');
        for (s) |c| {
            switch (c) {
                '"' => try self.buf.appendSlice(self.alloc, "\\\""),
                '\\' => try self.buf.appendSlice(self.alloc, "\\\\"),
                '\n' => try self.buf.appendSlice(self.alloc, "\\n"),
                '\r' => try self.buf.appendSlice(self.alloc, "\\r"),
                '\t' => try self.buf.appendSlice(self.alloc, "\\t"),
                0x00...0x08, 0x0b...0x0c, 0x0e...0x1f => {
                    var b: [6]u8 = undefined;
                    const t = std.fmt.bufPrint(&b, "\\u{x:0>4}", .{c}) catch unreachable;
                    try self.buf.appendSlice(self.alloc, t);
                },
                else => try self.buf.append(self.alloc, c),
            }
        }
        try self.buf.append(self.alloc, '"');
    }

    pub fn field(self: *Writer, key: []const u8) !void {
        try self.str(key);
        try self.buf.append(self.alloc, ':');
    }

    pub fn escapeInto(list: *std.ArrayList(u8), alloc: std.mem.Allocator, s: []const u8) !void {
        var w = Writer{ .buf = list, .alloc = alloc };
        try w.str(s);
    }
};

/// Serializes a Value into JSON text appended to `w`.
pub fn stringify(v: *const Value, w: *Writer) !void {
    switch (v.*) {
        .null => try w.raw("null"),
        .bool => |b| try w.raw(if (b) "true" else "false"),
        .int => |i| {
            var b: [24]u8 = undefined;
            try w.raw(std.fmt.bufPrint(&b, "{d}", .{i}) catch unreachable);
        },
        .float => |f| {
            var b: [40]u8 = undefined;
            try w.raw(std.fmt.bufPrint(&b, "{d}", .{f}) catch unreachable);
        },
        .str => |s| try w.str(s),
        .arr => |a| {
            try w.raw("[");
            for (a, 0..) |*e, i| {
                if (i != 0) try w.raw(",");
                try stringify(e, w);
            }
            try w.raw("]");
        },
        .obj => |o| {
            try w.raw("{");
            for (o, 0..) |*e, i| {
                if (i != 0) try w.raw(",");
                try w.field(e.key);
                try stringify(&e.val, w);
            }
            try w.raw("}");
        },
    }
}
