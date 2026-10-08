//! JSON value model: tagged union, owned-memory teardown, object lookup.
const std = @import("std");

pub const Value = union(enum) {
    null,
    bool: bool,
    int: i64,
    float: f64,
    str: []const u8,
    arr: []Value,
    obj: []Entry,

    pub const Entry = struct { key: []const u8, val: Value };

    pub fn deinit(self: *Value, alloc: std.mem.Allocator) void {
        switch (self.*) {
            .str => |s| alloc.free(s),
            .arr => |*a| {
                for (a.*) |*v| v.deinit(alloc);
                alloc.free(a.*);
            },
            .obj => |*o| {
                for (o.*) |*e| {
                    e.val.deinit(alloc);
                    alloc.free(e.key);
                }
                alloc.free(o.*);
            },
            else => {},
        }
        self.* = .null;
    }

    pub fn get(self: *const Value, key: []const u8) ?*const Value {
        if (self.* != .obj) return null;
        for (self.obj) |*e| {
            if (std.mem.eql(u8, e.key, key)) return &e.val;
        }
        return null;
    }
};
