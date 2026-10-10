//! CLI surface: usage text, option defaults, argument access.
const std = @import("std");
const build_options = @import("build_options");
const registry = @import("../core/registry.zig");
const ops = @import("../handlers.zig");
const sqlguard = @import("../util/sqlguard.zig");

/// Release version + commit, injected at build time from `git describe`
/// (issue 010): a clean `vX.Y.Z` checkout reports exactly `X.Y.Z`.
/// Tarball builds outside a checkout fall back to `0.1.0`/`unknown`.
pub const VERSION: []const u8 = build_options.version;
pub const COMMIT: []const u8 = build_options.commit;

pub const DEFAULT_BUSY = "C:\\BusyWin\\";
pub const DEFAULT_DATA = "C:\\BusyWin\\DATA\\";
pub const DEFAULT_PORT: u16 = 9820;
/// Default `--max-rows` cap for both transports (0 = unlimited when set
/// explicitly). Protects the single-threaded serve loop and clients alike.
pub const DEFAULT_MAX_ROWS: usize = 10_000;

pub const Usage =
    \\busy-bridge - programmatic interface over BUSY ERP's COM API surface
    \\
    \\usage:
    \\  busy-bridge classes                            list all registered BUSY COM classes
    \\  busy-bridge surface [--prog-id P] [--member M] dump IDispatch surface as JSON
    \\  busy-bridge query --comp C --sql "SELECT ..."  query open company (opens via OpenDB)
    \\       [--query-mode full|read-only|off] [--max-rows N]   guard (default full, 10000)
    \\  busy-bridge op <catalog|list|get>            ERP operations facade (normalized CRUD,
    \\       e.g. op list accounts [--limit N] [--q X]          mechanical handling internal)
    \\       e.g. op get voucher 1290 --comp C / op list vouchers --type sale
    \\  busy-bridge call --method M [--args '[..]']    invoke any COM method, JSON args,
    \\       [--prog-id P] [--comp C]                   {"$byref": v} marks out-params
    \\       [--enumerate-ret]                          VT_DISPATCH return -> JSON array
    \\                                                  (VB6 Collection Count/Item walk)
    \\  busy-bridge record --comp C [--out F]          record golden reads as JSONL
    \\       transcript for replay CI (needs BUSY; default F=transcript.jsonl)
    \\  busy-bridge serve [--port 9820] [--host H]     HTTP JSON API: GET /surface /classes
    \\       [--comp C] [--prog-id P]                   POST /query {"sql":..} /call {"method":..}
    \\       [--query-mode full|read-only|off]          guard (serve defaults to read-only)
    \\       [--max-rows N]                             row cap (default 10000; 0 = unlimited)
    \\       [--token T]                                auth token (or BUSY_BRIDGE_TOKEN env);
    \\                                              non-loopback --host refuses without it
    \\       [--require-session]                        BUSY-011: /v1+/op need a user session
    \\                                              (POST /auth/login; see docs/auth-contract.md)
    \\       [--super-user NAME]                        provisional full-rights identity
    \\                                              (default Admin; others deny-all)
    \\       [--session-idle-ttl S] [--session-abs-ttl S]  session TTLs (default 43200/604800)
    \\  busy-bridge version
    \\
    \\common options: --prog-id (default: auto-discovered newest registered
    \\                  Busy2L*.CFixedInterface; error if BUSY not installed)
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

    /// Valueless flag presence (`--require-session`), anywhere in argv —
    /// `get` needs a value token after the key and cannot see a trailing
    /// bare flag.
    pub fn flag(self: Cli, key: []const u8) bool {
        for (self.items) |it| {
            if (std.mem.eql(u8, it, key)) return true;
        }
        return false;
    }

    pub fn getOr(self: Cli, key: []const u8, dflt: []const u8) []const u8 {
        return self.get(key) orelse dflt;
    }
};

/// Resolve open options. `--prog-id` wins; otherwise the newest registered
/// Busy2L*.CFixedInterface is discovered from the registry (issue #1), so a
/// BUSY upgrade needs no flag/code change. error.NoBusyProgId when nothing
/// is registered (BUSY not installed).
pub fn optsFrom(cli: Cli) !ops.OpenOpts {
    const prog = cli.get("--prog-id") orelse
        (registry.newestFixedInterface() orelse return error.NoBusyProgId);
    return .{
        .prog_id = prog,
        .busy = cli.getOr("--busy", DEFAULT_BUSY),
        .data = cli.getOr("--data", DEFAULT_DATA),
        .comp = cli.get("--comp"),
    };
}

/// Query guard flags (issue #3): `--query-mode` (caller supplies the
/// transport default: "full" for `query`, "read-only" for `serve`) and
/// `--max-rows` (default DEFAULT_MAX_ROWS; 0 = unlimited).
/// Errors: error.BadQueryMode / error.BadMaxRows.
pub const Guard = struct { mode: sqlguard.Mode, max_rows: usize };

pub fn guardFrom(cli: Cli, default_mode: []const u8) !Guard {
    const m = sqlguard.parseMode(cli.getOr("--query-mode", default_mode)) orelse
        return error.BadQueryMode;
    const raw = cli.get("--max-rows") orelse
        return .{ .mode = m, .max_rows = DEFAULT_MAX_ROWS };
    const n = std.fmt.parseInt(usize, raw, 10) catch return error.BadMaxRows;
    return .{ .mode = m, .max_rows = n };
}
