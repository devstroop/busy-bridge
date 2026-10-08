//! JSON parser: recursive-descent text -> Value.
const std = @import("std");
const Value = @import("value.zig").Value;

pub const Parser = struct {
    src: []const u8,
    pos: usize = 0,
    alloc: std.mem.Allocator,

    pub fn parse(self: *Parser) !Value {
        self.ws();
        const v = try self.value();
        self.ws();
        return v;
    }

    // Skips whitespace. EOF here is fine: callers' peek()/value() report
    // missing content, and parse() legitimately ends at EOF after the value.
    fn ws(self: *Parser) void {
        while (self.pos < self.src.len and std.ascii.isWhitespace(self.src[self.pos])) self.pos += 1;
    }

    fn peek(self: *Parser) !u8 {
        if (self.pos >= self.src.len) return error.UnexpectedEnd;
        return self.src[self.pos];
    }

    // Explicit error set: breaks the value<->object/array inference loop.
    fn value(self: *Parser) anyerror!Value {
        const c = try self.peek();
        switch (c) {
            '{' => return self.object(),
            '[' => return self.array(),
            '"' => return .{ .str = try self.string() },
            't' => return self.lit("true", .{ .bool = true }),
            'f' => return self.lit("false", .{ .bool = false }),
            'n' => return self.lit("null", .null),
            '-', '0'...'9' => return self.number(),
            else => return error.UnexpectedChar,
        }
    }

    fn lit(self: *Parser, s: []const u8, v: Value) !Value {
        if (self.pos + s.len > self.src.len or
            !std.mem.eql(u8, self.src[self.pos .. self.pos + s.len], s)) return error.BadLiteral;
        self.pos += s.len;
        return v;
    }

    fn number(self: *Parser) !Value {
        const start = self.pos;
        if (self.src[self.pos] == '-') self.pos += 1;
        var is_float = false;
        while (self.pos < self.src.len) : (self.pos += 1) {
            const c = self.src[self.pos];
            if (c >= '0' and c <= '9') continue;
            if (c == '.' or c == 'e' or c == 'E' or c == '+' or c == '-') {
                is_float = true;
                continue;
            }
            break;
        }
        const txt = self.src[start..self.pos];
        if (is_float) return .{ .float = try std.fmt.parseFloat(f64, txt) };
        return .{ .int = try std.fmt.parseInt(i64, txt, 10) };
    }

    fn string(self: *Parser) ![]u8 {
        if (try self.peek() != '"') return error.ExpectString;
        self.pos += 1;
        var out: std.ArrayList(u8) = .empty;
        errdefer out.deinit(self.alloc);
        while (true) {
            if (self.pos >= self.src.len) return error.UnexpectedEnd;
            const c = self.src[self.pos];
            self.pos += 1;
            switch (c) {
                '"' => return out.toOwnedSlice(self.alloc),
                '\\' => {
                    if (self.pos >= self.src.len) return error.UnexpectedEnd;
                    const e = self.src[self.pos];
                    self.pos += 1;
                    switch (e) {
                        '"' => try out.append(self.alloc, '"'),
                        '\\' => try out.append(self.alloc, '\\'),
                        '/' => try out.append(self.alloc, '/'),
                        'n' => try out.append(self.alloc, '\n'),
                        'r' => try out.append(self.alloc, '\r'),
                        't' => try out.append(self.alloc, '\t'),
                        'b' => try out.append(self.alloc, 0x08),
                        'f' => try out.append(self.alloc, 0x0c),
                        'u' => {
                            if (self.pos + 4 > self.src.len) return error.BadEscape;
                            const cp = try std.fmt.parseInt(u16, self.src[self.pos .. self.pos + 4], 16);
                            self.pos += 4;
                            if (cp >= 0xD800 and cp <= 0xDBFF and self.pos + 6 <= self.src.len and
                                self.src[self.pos] == '\\' and self.src[self.pos + 1] == 'u')
                            {
                                const lo = try std.fmt.parseInt(u16, self.src[self.pos + 2 .. self.pos + 6], 16);
                                self.pos += 6;
                                const full: u21 = 0x10000 + (@as(u21, cp - 0xD800) << 10) + (lo - 0xDC00);
                                var buf: [4]u8 = undefined;
                                const n = try std.unicode.utf8Encode(full, &buf);
                                try out.appendSlice(self.alloc, buf[0..n]);
                            } else {
                                var buf: [4]u8 = undefined;
                                const n = try std.unicode.utf8Encode(@as(u21, cp), &buf);
                                try out.appendSlice(self.alloc, buf[0..n]);
                            }
                        },
                        else => return error.BadEscape,
                    }
                },
                else => try out.append(self.alloc, c),
            }
        }
    }

    fn array(self: *Parser) !Value {
        self.pos += 1; // [
        var list: std.ArrayList(Value) = .empty;
        errdefer {
            for (list.items) |*v| v.deinit(self.alloc);
            list.deinit(self.alloc);
        }
        self.ws();
        if (try self.peek() == ']') {
            self.pos += 1;
            return .{ .arr = try list.toOwnedSlice(self.alloc) };
        }
        while (true) {
            self.ws();
            try list.append(self.alloc, try self.value());
            self.ws();
            const c = try self.peek();
            self.pos += 1;
            if (c == ']') break;
            if (c != ',') return error.ExpectComma;
        }
        return .{ .arr = try list.toOwnedSlice(self.alloc) };
    }

    fn object(self: *Parser) !Value {
        self.pos += 1; // {
        var list: std.ArrayList(Value.Entry) = .empty;
        errdefer {
            for (list.items) |*e| e.val.deinit(self.alloc);
            list.deinit(self.alloc);
        }
        self.ws();
        if (try self.peek() == '}') {
            self.pos += 1;
            return .{ .obj = try list.toOwnedSlice(self.alloc) };
        }
        while (true) {
            self.ws();
            const key = try self.string();
            self.ws();
            if (try self.peek() != ':') return error.ExpectColon;
            self.pos += 1;
            self.ws();
            const v = try self.value();
            try list.append(self.alloc, .{ .key = key, .val = v });
            self.ws();
            const c = try self.peek();
            self.pos += 1;
            if (c == '}') break;
            if (c != ',') return error.ExpectComma;
        }
        return .{ .obj = try list.toOwnedSlice(self.alloc) };
    }
};

pub fn parse(alloc: std.mem.Allocator, src: []const u8) !Value {
    var p = Parser{ .src = src, .alloc = alloc };
    return p.parse();
}
