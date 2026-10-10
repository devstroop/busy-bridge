//! CallResult: the owned JSON shape of one COM invocation (return value
//! plus out-param values). Pure data — lives here (not in invoke.zig) so
//! host-agnostic code (replay, issue 009) can name the type without
//! touching FFI.
const std = @import("std");
const json = @import("../../util/json.zig");

const Allocator = std.mem.Allocator;

pub const CallResult = struct {
    ret: json.Value,
    outs: []json.Value,
    /// Retained VT_DISPATCH return (opts.retain_ret) — an ADDITIONAL
    /// reference owned by the CALLER (deinit does not release it; the
    /// caller Releases exactly once). anyopaque keeps this module
    /// host-agnostic (IDispatch lives in win32.zig).
    ret_disp: ?*anyopaque = null,

    pub fn deinit(self: *CallResult, alloc: Allocator) void {
        self.ret.deinit(alloc);
        for (self.outs) |*o| o.deinit(alloc);
        alloc.free(self.outs);
    }
};
