//! CLI dispatch (issue #11 phase 4): route a parsed argv to its command.
//! Split into responsibility-named submodules:
//!   commands/raw.zig  classes, surface, query, call, record — COM escape
//!                     hatch + transcript recorder (issue #9)
//!   commands/ops.zig  op verb dispatch — ERP facade (issue #7)
//! This file keeps the dispatcher + shared fail helpers, so the error
//! envelope is defined exactly once for every CLI failure path.
const std = @import("std");
const builtin = @import("builtin");
const helpers = @import("../util/helpers.zig");
const cli_mod = @import("cli.zig");
const format = @import("format.zig");
const http = @import("http.zig");

const Allocator = std.mem.Allocator;
const Io = std.Io;
const Cli = cli_mod.Cli;
const Format = format.Format;

const eql = helpers.eql;
const printOut = helpers.printOut;

const raw = @import("commands/raw.zig");
const ops_cmd = @import("commands/ops.zig");

/// Build an error payload in the active wire format (no printing).
/// `machine` is the stable branchable code (issue #2); `status` for XML is
/// the process exit code (always 1 for CLI failures).
pub fn failText(alloc: Allocator, fmt: Format, machine: []const u8, msg: []const u8) ![]u8 {
    return switch (fmt) {
        .json => @import("envelope.zig").errJsonText(alloc, machine, msg),
        .xml => format.errorXml(alloc, "1", machine, msg),
    };
}

/// Print an error in the active wire format and return the failure exit code.
pub fn fail(io: Io, alloc: Allocator, fmt: Format, machine: []const u8, msg: []const u8) !u8 {
    const t = try failText(alloc, fmt, machine, msg);
    defer alloc.free(t);
    try printOut(io, alloc, t);
    try printOut(io, alloc, "\n");
    return 1;
}

/// Route a parsed argv to its command. `cli.items[0]` is the command name.
pub fn run(io: Io, alloc: Allocator, cli: Cli) !u8 {
    if (cli.items.len == 0) {
        try printOut(io, alloc, cli_mod.Usage);
        return 1;
    }
    const cmd_name = cli.items[0];
    if (eql(cmd_name, "help") or eql(cmd_name, "--help") or eql(cmd_name, "-h")) {
        try printOut(io, alloc, cli_mod.Usage);
        return 0;
    }
    if (eql(cmd_name, "version")) {
        try printOut(io, alloc, "busy-bridge " ++ cli_mod.VERSION ++ " (commit " ++ cli_mod.COMMIT ++ ", zig " ++ comptime versionString() ++ ", x86-windows)\n");
        return 0;
    }
    // record runs BEFORE the --out format check: for this command the
    // documented flag is the transcript FILE path (default
    // transcript.jsonl), not the json|xml wire format (issue #9).
    if (eql(cmd_name, "record")) return raw.cmdRecord(io, alloc, cli); // JSONL transcript (issue #9)
    const fmt: Format = format.fromOutFlag(cli.getOr("--out", "json")) catch {
        return fail(io, alloc, .json, "bad_args", "invalid --out value (use json or xml)");
    };
    if (eql(cmd_name, "classes")) return raw.cmdClasses(io, alloc, fmt);
    if (eql(cmd_name, "surface")) return raw.cmdSurface(io, alloc, cli, fmt);
    if (eql(cmd_name, "query")) return raw.cmdQuery(io, alloc, cli, fmt);
    if (eql(cmd_name, "op")) return ops_cmd.cmdOp(io, alloc, cli, fmt); // ERP facade (issue #7)
    if (eql(cmd_name, "call")) return raw.cmdCall(io, alloc, cli, fmt);
    if (eql(cmd_name, "serve")) return http.serve(io, alloc, cli); // Accept-negotiated

    try printOut(io, alloc, "unknown command: ");
    try printOut(io, alloc, cmd_name);
    try printOut(io, alloc, "\n\n");
    try printOut(io, alloc, cli_mod.Usage);
    return 1;
}

fn versionString() []const u8 {
    comptime {
        return std.fmt.comptimePrint("{d}.{d}.{d}", .{
            builtin.zig_version.major,
            builtin.zig_version.minor,
            builtin.zig_version.patch,
        });
    }
}
