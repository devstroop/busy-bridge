//! CLI surface: usage text, option defaults, argument access.
const std = @import("std");
const ops = @import("../core/ops.zig");

pub const DEFAULT_PROG = "Busy2L21.CFixedInterface";
pub const DEFAULT_BUSY = "C:\\BusyWin\\";
pub const DEFAULT_DATA = "C:\\BusyWin\\DATA\\";
pub const DEFAULT_PORT: u16 = 9820;

pub const Usage =
    \\busy-bridge - programmatic interface over BUSY ERP's COM API surface
    \\
    \\usage:
    \\  busy-bridge classes                            list all registered BUSY COM classes
    \\  busy-bridge surface [--prog-id P] [--member M] dump IDispatch surface as JSON
    \\  busy-bridge query --comp C --sql "SELECT ..."  query open company (opens via OpenDB)
    \\  busy-bridge call --method M [--args '[..]']    invoke any COM method, JSON args,
    \\       [--prog-id P] [--comp C]                   {"$byref": v} marks out-params
    \\  busy-bridge serve [--port 9820] [--host H]     HTTP JSON API: GET /surface /classes
    \\       [--comp C] [--prog-id P]                   POST /query {"sql":..} /call {"method":..}
    \\  busy-bridge version
    \\
    \\common options: --prog-id (default Busy2L21.CFixedInterface)
    \\                --busy (default C:\BusyWin\) --data (default C:\BusyWin\DATA\)
    \\                --out json|xml: response format for data commands (default json;
    \\                serve negotiates per-request via the Accept header instead)
    \\                --args-b64 / --sql-b64: base64-encoded value (use from PowerShell
    \\                5.1+ to avoid its double-quote mangling of native args)
    \\
;

pub const Cli = struct {
    items: []const [:0]const u8,

    pub fn get(self: Cli, key: []const u8) ?[]const u8 {
        var i: usize = 1;
        while (i + 1 < self.items.len) : (i += 1) {
            if (std.mem.eql(u8, self.items[i], key)) return self.items[i + 1];
        }
        return null;
    }

    pub fn getOr(self: Cli, key: []const u8, dflt: []const u8) []const u8 {
        return self.get(key) orelse dflt;
    }
};

pub fn optsFrom(cli: Cli) ops.OpenOpts {
    return .{
        .prog_id = cli.getOr("--prog-id", DEFAULT_PROG),
        .busy = cli.getOr("--busy", DEFAULT_BUSY),
        .data = cli.getOr("--data", DEFAULT_DATA),
        .comp = cli.get("--comp"),
    };
}
