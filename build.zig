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

    const mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    mod.linkSystemLibrary("ole32", .{});
    mod.linkSystemLibrary("oleaut32", .{});
    mod.linkSystemLibrary("advapi32", .{}); // registry (classes enumeration)
    mod.linkSystemLibrary("ws2_32", .{}); // winsock (HTTP server)

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
    test_mod.linkSystemLibrary("ole32", .{});
    test_mod.linkSystemLibrary("oleaut32", .{});
    test_mod.linkSystemLibrary("advapi32", .{});
    test_mod.linkSystemLibrary("ws2_32", .{});
    const tests = b.addTest(.{ .root_module = test_mod });
    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);
}
