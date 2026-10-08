//! Minimal well-formed XML parser -> owned element tree.
//!
//! Real BUSY documents (see ../testdata/) are element-only with basic
//! entities and self-closing tags: no attributes, CDATA, comments, PIs,
//! declarations or BOM. The parser nevertheless tolerates that wider common
//! subset (except DTD semantics: DOCTYPE is skipped, not honored) so feeds
//! from other BUSY surfaces do not surprise us. Entity decoding is lenient:
//! an unresolvable `&...` is kept verbatim rather than rejected.
const std = @import("std");

const Allocator = std.mem.Allocator;

pub const Attr = struct { name: []const u8, value: []const u8 };

pub const Node = union(enum) {
    text: []const u8,
    element: Element,
};

pub const Element = struct {
    name: []const u8,
    selfclosing: bool = false,
    attrs: []Attr = &.{},
    children: []Node = &.{},

    pub fn deinit(self: *Element, alloc: Allocator) void {
        freeChildren(alloc, self.children);
        alloc.free(self.children);
        freeAttrs(alloc, self.attrs);
        alloc.free(self.attrs);
        alloc.free(self.name);
    }
};

pub fn freeAttrs(alloc: Allocator, attrs: []Attr) void {
    for (attrs) |a| {
        alloc.free(a.name);
        alloc.free(a.value);
    }
}

pub fn freeChildren(alloc: Allocator, nodes: []Node) void {
    for (nodes) |*n| switch (n.*) {
        .text => |t| alloc.free(t),
        .element => |*e| e.deinit(alloc),
    };
}

pub fn parse(alloc: Allocator, src: []const u8) !Element {
    var body = src;
    if (body.len >= 3 and body[0] == 0xEF and body[1] == 0xBB and body[2] == 0xBF)
        body = body[3..]; // strip UTF-8 BOM
    var p = Parser{ .alloc = alloc, .src = body };
    return p.document();
}

/// Decode `&amp; &lt; &gt; &quot; &apos; &#NN; &#xNN;`. Unknown or
/// unterminated references pass through unchanged (lenient bridge).
pub fn decodeEntities(alloc: Allocator, raw: []const u8) ![]u8 {
    if (std.mem.indexOfScalar(u8, raw, '&') == null) return alloc.dupe(u8, raw);
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);
    var i: usize = 0;
    while (i < raw.len) {
        if (raw[i] != '&') {
            try out.append(alloc, raw[i]);
            i += 1;
            continue;
        }
        const end = std.mem.indexOfScalarPos(u8, raw, i, ';') orelse {
            try out.append(alloc, '&'); // bare '&': keep verbatim
            i += 1;
            continue;
        };
        const ent = raw[i + 1 .. end];
        const bare = struct {
            fn put(list: *std.ArrayList(u8), a: Allocator, s: []const u8) !void {
                try list.appendSlice(a, s);
            }
        }.put;
        if (std.mem.eql(u8, ent, "amp")) {
            try bare(&out, alloc, "&");
        } else if (std.mem.eql(u8, ent, "lt")) {
            try bare(&out, alloc, "<");
        } else if (std.mem.eql(u8, ent, "gt")) {
            try bare(&out, alloc, ">");
        } else if (std.mem.eql(u8, ent, "quot")) {
            try bare(&out, alloc, "\"");
        } else if (std.mem.eql(u8, ent, "apos")) {
            try bare(&out, alloc, "'");
        } else if (ent.len >= 2 and ent[0] == '#') {
            const cp: u32 = if (ent[1] == 'x' or ent[1] == 'X')
                std.fmt.parseInt(u32, ent[2..], 16) catch {
                    try out.appendSlice(alloc, raw[i .. end + 1]);
                    i = end + 1;
                    continue;
                }
            else
                std.fmt.parseInt(u32, ent[1..], 10) catch {
                    try out.appendSlice(alloc, raw[i .. end + 1]);
                    i = end + 1;
                    continue;
                };
            if (cp > 0x10FFFF) {
                try out.appendSlice(alloc, raw[i .. end + 1]);
            } else {
                var b: [4]u8 = undefined;
                const n = std.unicode.utf8Encode(@intCast(cp), &b) catch {
                    try out.appendSlice(alloc, raw[i .. end + 1]);
                    i = end + 1;
                    continue;
                };
                try out.appendSlice(alloc, b[0..n]);
            }
        } else {
            try out.appendSlice(alloc, raw[i .. end + 1]); // unknown: verbatim
        }
        i = end + 1;
    }
    return out.toOwnedSlice(alloc);
}

const Parser = struct {
    alloc: Allocator,
    src: []const u8,
    pos: usize = 0,

    fn startsWith(self: *Parser, s: []const u8) bool {
        return std.mem.startsWith(u8, self.src[self.pos..], s);
    }

    fn skipWs(self: *Parser) void {
        while (self.pos < self.src.len and std.ascii.isWhitespace(self.src[self.pos])) self.pos += 1;
    }

    fn skipTo(self: *Parser, delim: []const u8) !void {
        const end = std.mem.indexOfPos(u8, self.src, self.pos, delim) orelse return error.UnexpectedEnd;
        self.pos = end + delim.len;
    }

    /// Skips `<!...>` constructs; honors `[...]` internal subsets.
    fn skipDecl(self: *Parser) !void {
        const gt = std.mem.indexOfScalarPos(u8, self.src, self.pos, '>') orelse return error.UnexpectedEnd;
        const br = std.mem.indexOfScalarPos(u8, self.src, self.pos, '[');
        if (br) |b| {
            if (b < gt) {
                const end = std.mem.indexOfPos(u8, self.src, b, "]>") orelse return error.UnexpectedEnd;
                self.pos = end + 2;
                return;
            }
        }
        self.pos = gt + 1;
    }

    /// Skips leading trivia: whitespace, PIs, comments, declarations.
    fn skipTrivia(self: *Parser) !void {
        while (true) {
            self.skipWs();
            if (self.startsWith("<?")) {
                try self.skipTo("?>");
            } else if (self.startsWith("<!--")) {
                try self.skipTo("-->");
            } else if (self.startsWith("<!")) {
                try self.skipDecl();
            } else return;
        }
    }

    fn document(self: *Parser) anyerror!Element {
        try self.skipTrivia();
        if (self.pos >= self.src.len or self.src[self.pos] != '<') return error.NoRoot;
        const root = try self.element();
        errdefer {
            var r = root; // root fully built; free it if trailing checks fail
            r.deinit(self.alloc);
        }
        try self.skipTrivia();
        if (self.pos != self.src.len) return error.TrailingContent;
        return root;
    }

    fn name(self: *Parser) ![]const u8 {
        if (self.pos >= self.src.len) return error.UnexpectedEnd;
        const c0 = self.src[self.pos];
        const is_start = std.ascii.isAlphabetic(c0) or c0 == '_' or c0 == ':';
        if (!is_start) return error.BadName;
        const start = self.pos;
        self.pos += 1;
        while (self.pos < self.src.len) : (self.pos += 1) {
            const c = self.src[self.pos];
            const ok = std.ascii.isAlphanumeric(c) or c == '_' or c == ':' or c == '-' or c == '.';
            if (!ok) break;
        }
        return self.alloc.dupe(u8, self.src[start..self.pos]);
    }

    fn attrValue(self: *Parser) ![]const u8 {
        if (self.pos >= self.src.len) return error.UnexpectedEnd;
        const q = self.src[self.pos];
        if (q != '"' and q != '\'') return error.BadAttrValue;
        self.pos += 1;
        const start = self.pos;
        while (self.pos < self.src.len and self.src[self.pos] != q) : (self.pos += 1) {}
        if (self.pos >= self.src.len) return error.UnexpectedEnd;
        const raw = self.src[start..self.pos];
        self.pos += 1; // closing quote
        return decodeEntities(self.alloc, raw);
    }

    fn element(self: *Parser) anyerror!Element {
        self.pos += 1; // consume '<'
        const tag = try self.name();
        errdefer self.alloc.free(tag);

        var attrs: std.ArrayList(Attr) = .empty;
        errdefer {
            freeAttrs(self.alloc, attrs.items);
            attrs.deinit(self.alloc);
        }

        var selfclosing = false;
        while (true) {
            self.skipWs();
            if (self.pos >= self.src.len) return error.UnexpectedEnd;
            if (self.startsWith("/>")) {
                self.pos += 2;
                selfclosing = true;
                break;
            }
            if (self.src[self.pos] == '>') {
                self.pos += 1;
                break;
            }
            const an = try self.name();
            errdefer self.alloc.free(an);
            self.skipWs();
            if (self.pos >= self.src.len or self.src[self.pos] != '=') return error.BadAttr;
            self.pos += 1;
            self.skipWs();
            const av = try self.attrValue();
            errdefer self.alloc.free(av);
            try attrs.append(self.alloc, .{ .name = an, .value = av });
        }

        var children: std.ArrayList(Node) = .empty;
        errdefer {
            freeChildren(self.alloc, children.items);
            children.deinit(self.alloc);
        }

        if (!selfclosing) {
            while (true) {
                if (self.pos >= self.src.len) return error.UnexpectedEnd;
                if (self.src[self.pos] != '<') {
                    // text run up to the next '<'
                    const start = self.pos;
                    while (self.pos < self.src.len and self.src[self.pos] != '<') : (self.pos += 1) {}
                    const raw = self.src[start..self.pos];
                    if (raw.len > 0) {
                        const t = try decodeEntities(self.alloc, raw);
                        errdefer self.alloc.free(t);
                        try children.append(self.alloc, .{ .text = t });
                    }
                    continue;
                }
                if (self.startsWith("</")) {
                    self.pos += 2;
                    const en = try self.name();
                    defer self.alloc.free(en);
                    if (!std.mem.eql(u8, en, tag)) return error.MismatchedTag;
                    self.skipWs();
                    if (self.pos >= self.src.len or self.src[self.pos] != '>') return error.BadTag;
                    self.pos += 1;
                    break;
                }
                if (self.startsWith("<!--")) {
                    try self.skipTo("-->");
                } else if (self.startsWith("<![CDATA[")) {
                    self.pos += 9;
                    const end = std.mem.indexOfPos(u8, self.src, self.pos, "]]>") orelse return error.UnexpectedEnd;
                    const raw = self.src[self.pos..end];
                    self.pos = end + 3;
                    if (raw.len > 0) {
                        const t = try self.alloc.dupe(u8, raw); // CDATA: no entity decoding
                        errdefer self.alloc.free(t);
                        try children.append(self.alloc, .{ .text = t });
                    }
                } else if (self.startsWith("<?")) {
                    try self.skipTo("?>");
                } else if (self.startsWith("<!")) {
                    try self.skipDecl();
                } else {
                    var child = try self.element();
                    errdefer child.deinit(self.alloc);
                    try children.append(self.alloc, .{ .element = child });
                }
            }
        }

        return .{
            .name = tag,
            .selfclosing = selfclosing,
            .attrs = try attrs.toOwnedSlice(self.alloc),
            .children = try children.toOwnedSlice(self.alloc),
        };
    }
};

// ---------------- tests ----------------

const testing = std.testing;

fn expectTree(src: []const u8, want: []const u8) !void {
    var doc = try parse(testing.allocator, src);
    defer doc.deinit(testing.allocator);
    try testing.expectEqualStrings(want, doc.name);
}

test "entities decode" {
    var doc = try parse(testing.allocator, "<A>a &amp; b &lt;c&gt; &#65; &#x42;</A>");
    defer doc.deinit(testing.allocator);
    try testing.expectEqualStrings("a & b <c> A B", doc.children[0].text);
}

test "lenient unknown and bare ampersand" {
    var doc = try parse(testing.allocator, "<A>x &y; 5 & 6 &#zz;</A>");
    defer doc.deinit(testing.allocator);
    try testing.expectEqualStrings("x &y; 5 & 6 &#zz;", doc.children[0].text);
}

test "attributes single and double quoted" {
    var doc = try parse(testing.allocator, "<A b='1' c=\"x&amp;y\"/>");
    defer doc.deinit(testing.allocator);
    try testing.expect(doc.selfclosing);
    try testing.expectEqual(@as(usize, 2), doc.attrs.len);
    try testing.expectEqualStrings("b", doc.attrs[0].name);
    try testing.expectEqualStrings("1", doc.attrs[0].value);
    try testing.expectEqualStrings("x&y", doc.attrs[1].value);
}

test "cdata is raw text" {
    var doc = try parse(testing.allocator, "<A><![CDATA[<x>&y;]]></A>");
    defer doc.deinit(testing.allocator);
    try testing.expectEqualStrings("<x>&y;", doc.children[0].text);
}

test "comments pis and doctype are skipped" {
    var doc = try parse(testing.allocator,
        \\<?xml version="1.0"?><!-- top --><!DOCTYPE A [<!ENTITY e "v">]><A><!-- in --><?pi data?><B/></A>
    );
    defer doc.deinit(testing.allocator);
    try testing.expectEqualStrings("A", doc.name);
    try testing.expectEqual(@as(usize, 1), doc.children.len);
    try expectTree("<A/>", "A");
}

test "nested structure" {
    var doc = try parse(testing.allocator, "<A><B><C>t</C></B><D/></A>");
    defer doc.deinit(testing.allocator);
    try testing.expectEqual(@as(usize, 2), doc.children.len);
    const b = doc.children[0].element;
    const c = b.children[0].element;
    try testing.expectEqualStrings("C", c.name);
    try testing.expectEqualStrings("t", c.children[0].text);
    try testing.expect(doc.children[1].element.selfclosing);
}

test "errors" {
    try testing.expectError(error.UnexpectedEnd, parse(testing.allocator, "<A"));
    try testing.expectError(error.MismatchedTag, parse(testing.allocator, "<A><B></A></B>"));
    try testing.expectError(error.NoRoot, parse(testing.allocator, "   "));
    try testing.expectError(error.TrailingContent, parse(testing.allocator, "<A/> junk"));
    try testing.expectError(error.BadAttr, parse(testing.allocator, "<A b '1'/>"));
}
