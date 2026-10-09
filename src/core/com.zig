//! COM layer for the BUSY bridge. Raw FFI lives in ./com/win32.zig; behavior
//! is split across ./com/{surface,invoke,recordset}.zig with Session state in
//! ./com/session.zig. This facade keeps the public API stable (`busyc.X`).
const std = @import("std");

pub const Allocator = std.mem.Allocator;
pub const Session = @import("com/session.zig").Session;
pub const Member = @import("com/surface.zig").Member;
pub const CallResult = @import("com/result.zig").CallResult;
pub const win32 = @import("com/win32.zig");
pub const utf16 = @import("com/utf16.zig");
