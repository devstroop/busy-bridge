//! Minimal JSON for the bridge (no external deps).
//! Facade over ./json/* — call sites keep importing "json.zig".
pub const Value = @import("json/value.zig").Value;
pub const Writer = @import("json/write.zig").Writer;
pub const Parser = @import("json/parse.zig").Parser;
pub const stringify = @import("json/write.zig").stringify;
pub const parse = @import("json/parse.zig").parse;
