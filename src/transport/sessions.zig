//! Multi-company serve sessions (issue #5): per-request company selection
//! over a single swap-based COM session.
//!
//! Live probing (2026-10-09, Rel 14, DEMO) established the constraint that
//! decides this design: BUSY's COM server keeps **process-global,
//! first-open-wins** company state. Two dispatches created in one process
//! both answer for whichever company was `OpenDB`'ed *first* — a second
//! `OpenDB` returns true but silently does not switch (verified with a
//! marker master present in only one of two cloned companies). A parallel
//! session pool is therefore impossible in-process; the only correct
//! mechanism is `CloseDB` + `OpenDB` swap on one session (verified: switch
//! A→B→A returns each company's own data).
//!
//! So the "pool" has exactly one occupant: `Switcher` tracks the currently
//! open company and swaps on demand. Concurrency: the serve accept loop is
//! single-threaded, so switches and requests are serialized — which COM's
//! STA apartment requires anyway (see README, "Query safety"/Security).
//! Cost: a swap is BUSY's own CloseDB+OpenDB, ~7s measured live (2026-10-09)
//! — cheap requests are fast, but per-request company hopping is not; apps
//! should send bursts per company or run one serve process per hot company.

const std = @import("std");
const Io = std.Io;
const busyc = @import("../core/com.zig");
const ops = @import("../handlers.zig");

const Allocator = std.mem.Allocator;
const eql = std.ascii.eqlIgnoreCase;

pub const Switcher = struct {
    alloc: Allocator,
    io: Io,
    sess: busyc.Session,
    /// Base options (prog_id/busy/data); `comp` is the default company.
    opts: ops.OpenOpts,
    /// Owned code of the currently open company, or null (none).
    current: ?[]u8 = null,
    /// Number of successful company switches (observed via /info).
    switches: u64 = 0,

    /// Initialize and eagerly open the default company (back-compat: serve
    /// still fails fast at boot when `--comp` cannot be opened).
    pub fn init(alloc: Allocator, io: Io, opts: ops.OpenOpts) !Switcher {
        var s = try busyc.Session.init(alloc);
        errdefer s.deinit();
        var sw = Switcher{ .alloc = alloc, .io = io, .sess = s, .opts = opts };
        if (opts.comp) |c| {
            if (!companyDirExists(io, opts.data, c)) return error.CompanyNotFound;
            try ops.openSession(&sw.sess, opts);
            sw.current = try alloc.dupe(u8, c);
        } else {
            try ops.openSession(&sw.sess, opts);
        }
        return sw;
    }

    pub fn deinit(self: *Switcher) void {
        if (self.current) |c| {
            ops.closeCompany(&self.sess) catch {};
            self.alloc.free(c);
            self.current = null;
        }
        self.sess.deinit();
    }

    /// Ensure `want` is the open company (null = the serve default).
    /// No-op when already open. Swaps via CloseDB+OpenDB otherwise.
    /// `error.CompanyNotFound` when the company directory is absent.
    pub fn ensure(self: *Switcher, want: ?[]const u8) !void {
        const comp_want = want orelse self.opts.comp orelse return;
        if (self.current) |cur| {
            if (eql(cur, comp_want)) return;
        }
        if (!companyDirExists(self.io, self.opts.data, comp_want)) return error.CompanyNotFound;
        const prev = self.current; // owned; may be null
        if (self.current != null) ops.closeCompany(&self.sess) catch {};
        var o = self.opts;
        o.comp = comp_want;
        ops.openCompany(&self.sess, o) catch |err| {
            // Best-effort restore of the previous company so one bad
            // request doesn't leave the serve process company-less.
            if (prev) |p| {
                var ro = self.opts;
                ro.comp = p;
                ops.openCompany(&self.sess, ro) catch {};
            }
            return err;
        };
        const owned = try self.alloc.dupe(u8, comp_want);
        if (self.current) |old| self.alloc.free(old);
        self.current = owned;
        self.switches += 1;
    }
};

/// Does `<data>/<comp>` exist on disk (file-mode company directory)?
/// Cheap pre-flight so an unknown company maps to `company_not_found`
/// (404) instead of a raw COM path exception (500).
fn companyDirExists(io: Io, data: []const u8, comp: []const u8) bool {
    var buf: [1024]u8 = undefined;
    const p = std.fmt.bufPrint(&buf, "{s}{c}{s}", .{
        std.mem.trimEnd(u8, data, "\\/"),
        std.fs.path.sep,
        comp,
    }) catch return false;
    std.Io.Dir.cwd().access(io, p, .{}) catch return false;
    return true;
}

test "companyDirExists joins paths with and without trailing separator" {
    const io = std.testing.io;
    // C:\BusyWin\DATA\COMP0001 exists in the live test environment; in CI
    // it doesn't — only assert the negative side plus no-crash on limits.
    try std.testing.expect(!companyDirExists(io, "Z:\\nonexistent\\", "COMP"));
    try std.testing.expect(!companyDirExists(io, "Z:\\nonexistent", "COMP"));
    // Absolute data path beyond the buffer must fail closed, not crash.
    const huge_data: [2000]u8 = @splat('x');
    try std.testing.expect(!companyDirExists(io, &huge_data, "COMP"));
}
