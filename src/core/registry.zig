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
