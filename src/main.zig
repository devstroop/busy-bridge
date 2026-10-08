//! busy-bridge: modern programmatic interface over the BUSY ERP COM surface.
//!
//! Commands:
//!   busy-bridge classes                      enumerate all registered BUSY ProgIDs
//!   busy-bridge surface [--prog-id P] [--member M]
//!                                            dump the full IDispatch surface as JSON
//!   busy-bridge query --comp C --sql SQL     run SQL against an open company -> JSON rows
//!   busy-bridge call --method M [--args J]   invoke any COM method with JSON args
//!   busy-bridge serve [--port N] [--comp C]  local HTTP JSON API over the same ops
//!   busy-bridge version | help
//!
//! Long options: --prog-id --busy --data --comp --sql --method --args --port --host
//!
//! This entry point only collects argv; command logic lives in commands.zig.
const std = @import("std");
const commands = @import("transport/commands.zig");

pub fn main(init: std.process.Init) !u8 {
    const io = init.io;
    const alloc = init.gpa;

    var list: std.ArrayList([:0]const u8) = .empty;
    defer list.deinit(alloc);
    // Windows arg iterator reuses one internal buffer -> duplicate each arg.
    var it = try init.minimal.args.iterateAllocator(alloc);
    defer it.deinit();
    _ = it.next(); // skip argv[0] (program path)
    while (it.next()) |a| {
        const dup = try alloc.allocSentinel(u8, a.len, 0);
        @memcpy(dup, a);
        list.append(alloc, dup) catch return 1;
    }
    const items = try list.toOwnedSlice(alloc);
    defer {
        for (items) |a| alloc.free(a);
        alloc.free(items);
    }

    return commands.run(io, alloc, .{ .items = items });
}
