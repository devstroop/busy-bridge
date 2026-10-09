//! Host replay root (issue 009): the package rule roots modules at the
//! file's directory, so the host binary must root here at src/ level.
//! Hops through transport (root -> transport is the only legal root
//! import) to the replay suites; never touches COM-touching modules, so
//! it compiles and runs natively on Linux/macOS/Windows with no BUSY.
test "replay root" {
    _ = @import("transport/replay_suite.zig");
}
