//! Session-boundary record/replay (issue 009): JSONL transcripts plus a
//! host-agnostic Replay for CI depth where no BUSY exists.
//!
//! Pure facade: the replay suites live in `replay/tests.zig` (aggregated
//! into both test binaries from there). The recorder (`record.zig`, BUSY
//! machine only) captures real invoke / query traffic; driving `handlers`
//! against Replay (comptime session interface) is the documented
//! follow-up in 009.
const std = @import("std");

pub const Replay = @import("replay/engine.zig").Replay;
pub const transcript_format = @import("replay/engine.zig").transcript_format;
