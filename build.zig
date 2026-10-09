const std = @import("std");

// busy-bridge: modern programmatic interface over the BUSY ERP COM surface.
// Built as 32-bit x86 Windows binary because BUSY's COM servers
// (C:\BusyWin\SYSTEM\Busy2L21.dll) are 32-bit in-process DLLs.
pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .x86,
        .os_tag = .windows,
        .abi = .gnu,
    });

    // Release version + commit from git (issue 010): `git describe`
    // names the build (`v0.1.0` -> `0.1.0`); tarball builds without a
    // checkout fall back to the last known release.
    const info = gitInfo(b);
    const options = b.addOptions();
    options.addOption([]const u8, "version", info.version);
    options.addOption([]const u8, "commit", info.commit);
    const build_options = options.createModule();

    const mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    mod.addImport("build_options", build_options);
    mod.linkSystemLibrary("ole32", .{});
    mod.linkSystemLibrary("oleaut32", .{});
    mod.linkSystemLibrary("advapi32", .{}); // registry (classes enumeration)
    mod.linkSystemLibrary("ws2_32", .{}); // winsock (HTTP server)
    mod.linkSystemLibrary("bcrypt", .{}); // BCryptGenRandom (session tokens)

    const exe = b.addExecutable(.{
        .name = "busy-bridge",
        .root_module = mod,
    });
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run busy-bridge");
    run_step.dependOn(&run_cmd.step);

    // Unit tests: one root (src/main.zig) so the whole src/ tree is inside
    // the module path; tests in transitively imported files all run
    // (util/xml codec, util/helpers, core/xmlmeta, transport/format).
    // The test binary is x86-windows-gnu, so run this step on Windows (CI).
    const test_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    test_mod.addImport("build_options", build_options);
    test_mod.linkSystemLibrary("ole32", .{});
    test_mod.linkSystemLibrary("oleaut32", .{});
    test_mod.linkSystemLibrary("advapi32", .{});
    test_mod.linkSystemLibrary("ws2_32", .{});
    test_mod.linkSystemLibrary("bcrypt", .{});
    const tests = b.addTest(.{ .root_module = test_mod });
    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);

    // Replay suite (issue 009): host-native binary running only the
    // host-agnostic replay tests — the entry root never touches COM, so
    // it compiles and runs on Linux + Windows CI with no BUSY.
    const replay_mod = b.createModule(.{
        .root_source_file = b.path("src/replay.zig"),
        .target = b.graph.host,
    });
    const replay_tests = b.addTest(.{ .root_module = replay_mod });
    const run_replay = b.addRunArtifact(replay_tests);
    const replay_step = b.step("replay-test", "Run host-agnostic replay tests");
    replay_step.dependOn(&run_replay.step);
}

const VersionInfo = struct { version: []const u8, commit: []const u8 };

/// Version + commit from git, or the fallback outside a checkout.
fn gitInfo(b: *std.Build) VersionInfo {
    const fallback = VersionInfo{ .version = "0.1.0", .commit = "unknown" };
    const desc = runGit(b, &.{ "git", "describe", "--tags", "--always", "--dirty" }) orelse return fallback;
    const sha = runGit(b, &.{ "git", "rev-parse", "--short", "HEAD" }) orelse return fallback;
    const dirty = std.mem.endsWith(u8, desc, "-dirty");
    const tag = if (dirty) desc[0 .. desc.len - "-dirty".len] else desc;
    // `v0.1.0-3-gabc1234` stays as-is (distance from the tag is signal);
    // a clean tag checkout yields exactly the release version.
    const version = if (std.mem.startsWith(u8, tag, "v")) tag[1..] else tag;
    const commit = if (dirty)
        std.fmt.allocPrint(b.allocator, "{s}-dirty", .{sha}) catch return fallback
    else
        sha;
    return .{ .version = version, .commit = commit };
}

/// Run git and return trimmed stdout (arena-lived), or null when git is
/// missing/failing. Uses `runFallible` so a missing git never fails
/// the build — the fallback above applies instead.
fn runGit(b: *std.Build, argv: []const []const u8) ?[]const u8 {
    switch (b.runFallible(argv, .{})) {
        .success => |stdout| return std.mem.trim(u8, stdout, " \t\r\n"),
        else => return null,
    }
}
