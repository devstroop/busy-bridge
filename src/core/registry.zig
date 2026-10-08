//! Registry enumeration: list registered `Busy*` COM ProgIDs (32-bit view).
const std = @import("std");

const Allocator = std.mem.Allocator;

const HKEY_LOCAL_MACHINE: ?*anyopaque = @ptrFromInt(0x80000002);
const KEY_READ: u32 = 0x20019;
const ERROR_SUCCESS: i32 = 0;
const ERROR_MORE_DATA: i32 = 234;
const ERROR_NO_MORE_ITEMS: i32 = 259;

extern "advapi32" fn RegOpenKeyExA(
    hKey: ?*anyopaque,
    lpSubKey: [*:0]const u8,
    ulOptions: u32,
    samDesired: u32,
    phkResult: *?*anyopaque,
) callconv(.winapi) i32;
extern "advapi32" fn RegEnumKeyExA(
    hKey: ?*anyopaque,
    dwIndex: u32,
    lpName: [*]u8,
    lpcchName: *u32,
    lpReserved: ?*u32,
    lpClass: ?[*]u8,
    lpcchClass: ?*u32,
    lpftLastWriteTime: ?*anyopaque,
) callconv(.winapi) i32;
extern "advapi32" fn RegCloseKey(hKey: ?*anyopaque) callconv(.winapi) i32;

pub fn listBusyClasses(alloc: Allocator) ![][]const u8 {
    var h: ?*anyopaque = null;
    if (RegOpenKeyExA(HKEY_LOCAL_MACHINE, "SOFTWARE\\Classes", 0, KEY_READ, &h) != ERROR_SUCCESS)
        return error.RegistryOpenFailed;
    defer _ = RegCloseKey(h);
    var out: std.ArrayList([]const u8) = .empty;
    errdefer {
        for (out.items) |s| alloc.free(s);
        out.deinit(alloc);
    }
    var i: u32 = 0;
    while (true) : (i += 1) {
        var name: [512]u8 = undefined;
        var n: u32 = name.len;
        const rc = RegEnumKeyExA(h, i, &name, &n, null, null, null, null);
        if (rc == ERROR_NO_MORE_ITEMS) break;
        if (rc == ERROR_MORE_DATA) continue; // oversized key: skip
        if (rc != ERROR_SUCCESS) return error.RegistryEnumFailed;
        const key = name[0..n];
        if (std.mem.startsWith(u8, key, "Busy"))
            try out.append(alloc, try alloc.dupe(u8, key));
    }
    return out.toOwnedSlice(alloc);
}

/// Newest registered version-suffixed CFixedInterface ProgID
/// (Busy2L21.CFixedInterface beats Busy2L17.CFixedInterface), or null when
/// no `Busy2L<n>.CFixedInterface` is registered (BUSY not installed).
/// Read-only registry scan — no COM probing, no registry side effects.
/// Returns a process-lifetime static buffer slice; never freed by callers.
pub fn newestFixedInterface() ?[]const u8 {
    var h: ?*anyopaque = null;
    if (RegOpenKeyExA(HKEY_LOCAL_MACHINE, "SOFTWARE\\Classes", 0, KEY_READ, &h) != ERROR_SUCCESS)
        return null;
    defer _ = RegCloseKey(h);
    var found = false;
    var best_gen: u32 = 0;
    var i: u32 = 0;
    while (true) : (i += 1) {
        var name: [512]u8 = undefined;
        var n: u32 = name.len;
        const rc = RegEnumKeyExA(h, i, &name, &n, null, null, null, null);
        if (rc == ERROR_NO_MORE_ITEMS) break;
        if (rc != ERROR_SUCCESS) continue; // skip unreadable/truncated keys
        if (fixedInterfaceGeneration(name[0..n])) |gen| {
            if (!found or gen > best_gen) {
                found = true;
                best_gen = gen;
            }
        }
    }
    if (!found) return null;
    const s = std.fmt.bufPrint(&newest_buf, "Busy2L{d:0>2}.CFixedInterface", .{best_gen}) catch return null;
    return s;
}

var newest_buf: [64]u8 = undefined;

/// "Busy2L21.CFixedInterface" -> 21; null for anything else.
pub fn fixedInterfaceGeneration(name: []const u8) ?u32 {
    const suffix = ".CFixedInterface";
    if (!std.mem.endsWith(u8, name, suffix)) return null;
    const head = name[0 .. name.len - suffix.len];
    const prefix = "Busy2L";
    if (!std.mem.startsWith(u8, head, prefix)) return null;
    const digits = head[prefix.len..];
    if (digits.len == 0) return null;
    return std.fmt.parseInt(u32, digits, 10) catch null;
}

test "fixedInterfaceGeneration" {
    const testing = std.testing;
    try testing.expectEqual(@as(u32, 21), fixedInterfaceGeneration("Busy2L21.CFixedInterface").?);
    try testing.expectEqual(@as(u32, 17), fixedInterfaceGeneration("Busy2L17.CFixedInterface").?);
    try testing.expectEqual(@as(u32, 99), fixedInterfaceGeneration("Busy2L99.CFixedInterface").?);
    try testing.expect(null == fixedInterfaceGeneration("Busy2L21.CMasterServices"));
    try testing.expect(null == fixedInterfaceGeneration("Busy2L.CFixedInterface"));
    try testing.expect(null == fixedInterfaceGeneration("Busy2LXX.CFixedInterface"));
    try testing.expect(null == fixedInterfaceGeneration("BusyExt21.CFixedInterface"));
    try testing.expect(null == fixedInterfaceGeneration("CFixedInterface"));
}
