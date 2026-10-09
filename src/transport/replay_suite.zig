//! Host replay entry (issue 009): pulls only the host-agnostic suites.
//!
//! Lives in transport (not src/ root) so the layer gate's root rule
//! (main imports transport only) keeps holding. The main test binary
//! targets x86-windows and links COM; this root keeps the replay binary
//! free of every COM-touching module so it compiles and runs natively
//! on Linux/macOS/Windows with no BUSY.
test "replay entry" {
    _ = @import("../core/com/replay/tests.zig");
}
