//! UDT instancing via IRecordInfo (the VT_RECORD wall — probe report
//! §12): HREFTYPEs resolve through the proven GetRefTypeInfo path
//! (typelib FindName/GetContainingTypeLib are unstable headless);
//! record instances are zeroed, field-filled via VARDESC indices, and
//! handed back as VT_RECORD VARIANTs.
const std = @import("std");
const Session = @import("session.zig").Session;
const win32 = @import("win32.zig");
const json = @import("../../util/json.zig");
const marshal = @import("marshal.zig");
const helpers = @import("../../util/helpers.zig");

const Allocator = std.mem.Allocator;
const ITypeInfo = win32.ITypeInfo;
const VARIANT = win32.VARIANT;
const SysFreeString = win32.SysFreeString;
const SysAllocString = win32.SysAllocString;
const VariantClear = win32.VariantClear;

fn jstr(v: *const json.Value) ?[]const u8 {
    return if (v.* == .str) v.str else null;
}
fn jf64(v: *const json.Value) ?f64 {
    return switch (v.*) {
        .float => |f| f,
        .int => |i| @floatFromInt(i),
        else => null,
    };
}
fn ji64(v: *const json.Value) ?i64 {
    return if (v.* == .int) v.int else null;
}
fn jbool(v: *const json.Value) ?bool {
    return if (v.* == .bool) v.bool else null;
}

// UDT typelib description (name/size/field layout) lives in
// udtdesc.zig (011 size-gate split); re-exported so import paths
// and call sites never change.
pub const FieldDesc = @import("udtdesc.zig").FieldDesc;
pub const UdtDesc = @import("udtdesc.zig").UdtDesc;
pub const describeParamUdt = @import("udtdesc.zig").describeParamUdt;
pub const describeHreftype = @import("udtdesc.zig").describeHreftype;
pub const describeUdtTi = @import("udtdesc.zig").describeUdtTi;

// (describeParamUdt/describeHreftype/describeUdtTi moved to udtdesc.zig — re-exported above.)

/// One COM-owned value embedded in a hand-built record buffer — the
/// RecBox cleanup walk releases these (VT_BSTR fields inside records
/// were process-lifetime before §22; embedded Collections are new).
pub const OwnedField = struct { off: u32, vt: u16 };

/// A built record: the boxed VARIANT plus the embedded COM-owned
/// fields the RecBox must release before freeing the buffer.
pub const RecordInst = struct {
    variant: VARIANT,
    owned: []const OwnedField,
    /// RecBox chain for record items inside embedded `$collection`
    /// fields (T3) — attached to the enclosing arg's box via
    /// RecBox.next, freed with it after the invoke.
    coll_recs: ?*marshal.RecBox = null,
};

/// Release the COM-owned values embedded in a record buffer
/// (VT_BSTR -> SysFreeString, VT_DISPATCH -> Release). Called by the
/// RecBox cleanup and the record-build error path.
pub fn releaseOwned(buf: [*]u8, owned: []const OwnedField) void {
    for (owned) |o| switch (o.vt) {
        8 => { // VT_BSTR
            const p = @as(*align(1) ?[*:0]u16, @ptrCast(buf + o.off)).*;
            if (p) |s| SysFreeString(s);
        },
        26 => { // VT_DISPATCH (embedded Collection)
            const p = @as(*align(1) ?*win32.IDispatch, @ptrCast(buf + o.off)).*;
            if (p) |d| _ = d.vtbl.Release(d);
        },
        else => {},
    };
}

/// IRecordInfo for a UDT ITypeInfo (oleaut32 export).
pub fn recordInfoFor(sess: *Session, ti_udt: *ITypeInfo) !*win32.IRecordInfo {
    var ri: ?*anyopaque = null;
    const hr = win32.GetRecordInfoFromTypeInfo(ti_udt, &ri);
    if (hr < 0 or ri == null) {
        sess.setErr("GetRecordInfoFromTypeInfo failed 0x{x}", .{@as(u32, @bitCast(hr))});
        return error.RecordInfo;
    }
    return @ptrCast(@alignCast(ri));
}

/// Live vtable calibration (BUSY_REC_CAL=1): probe IRecordInfo slots
/// 3..17 with (ri, *u32) and print hr/value — GetSize returns the
/// TYPEATTR size (5600 for udtRepOptions), GetFieldCount a small count.
pub fn calibrate(ri: *win32.IRecordInfo) void {
    var s: usize = 3;
    while (s < 18) : (s += 1) {
        var v: u32 = 0;
        const fnp: *const fn (*win32.IRecordInfo, *u32) callconv(.winapi) i32 = @ptrFromInt(@intFromPtr(ri.vtbl) + s * 4);
        const r = fnp(ri, &v);
        std.debug.print("[cal] slot {d}: hr=0x{x} v={d}\n", .{ s, @as(u32, @bitCast(r)), v });
    }
}

/// Hand-build a UDT instance from its layout (VARDESC offsets+vtypes)
/// — the IRecordInfo vtable is trap-thunked headless, so bytes are
/// packed manually. Returns RecordInst: the VT_BYREF|VT_RECORD
/// variant (byref = struct ptr; size stashed in variant r2 for the
/// caller's cleanup box) + the embedded COM-owned fields to release.
pub fn recordFromUdtTi(
    sess: *Session,
    alloc: Allocator,
    ti_udt: *ITypeInfo,
    hreftype: u32,
    fields: *const json.Value,
) !RecordInst {
    const desc = (try describeUdtTi(alloc, ti_udt, hreftype)) orelse {
        sess.setErr("UDT describe failed", .{});
        return error.RecordInfo;
    };
    var d = desc;
    defer d.deinit(alloc);
    if (d.size == 0 or d.size > (1 << 20)) return error.RecordInfo;

    const buf = alloc.alloc(u8, d.size) catch return error.OutOfMemory;
    errdefer alloc.free(buf);
    @memset(buf, 0);
    var owned: std.ArrayList(OwnedField) = .empty;
    // T3: record items built inside embedded $collection fields — the
    // caller frees the chain via RecBox.next (or this errdefer).
    var coll_recs: ?*marshal.RecBox = null;
    errdefer marshal.freeRecChain(alloc, coll_recs);
    errdefer {
        releaseOwned(buf.ptr, owned.items);
        owned.deinit(alloc);
    }

    if (fields.* == .obj) {
        for (fields.obj) |entry| {
            if (entry.key.len > 0 and entry.key[0] == '$') continue; // $cal etc.
            var fd: ?FieldDesc = null;
            for (d.fields) |f| {
                if (std.mem.eql(u8, f.name, entry.key)) {
                    fd = f;
                    break;
                }
            }
            const f = fd orelse continue;
            const dst: [*]u8 = buf.ptr + f.off;
            switch (f.vt) {
                // VT_BSTR.
                8 => {
                    var wb: [512]u16 = undefined;
                    const s = jstr(&entry.val) orelse continue;
                    const n = sess.toWideFixed(s, &wb) catch continue;
                    wb[n] = 0;
                    const b = SysAllocString(@ptrCast(wb[0..n].ptr));
                    @as(*align(1) ?[*:0]u16, @ptrCast(dst)).* = b;
                    if (b != null) try owned.append(alloc, .{ .off = f.off, .vt = 8 });
                },
                // VT_DATE / VT_R8.
                7, 5 => {
                    const v: f64 = if (entry.val == .str)
                        helpers.dateToOle(entry.val.str) orelse jf64(&entry.val) orelse 0
                    else
                        jf64(&entry.val) orelse 0;
                    @as(*align(1) f64, @ptrCast(dst)).* = v;
                },
                // VT_R4.
                4 => {
                    @as(*align(1) f32, @ptrCast(dst)).* = @floatCast(jf64(&entry.val) orelse 0);
                },
                // VT_I4 / VT_INT / VT_ERROR.
                3, 22, 10 => {
                    @as(*align(1) i32, @ptrCast(dst)).* = @intCast((ji64(&entry.val) orelse @as(i64, @intFromFloat(jf64(&entry.val) orelse 0))));
                },
                // VT_I2.
                2 => {
                    @as(*align(1) i16, @ptrCast(dst)).* = @intCast(ji64(&entry.val) orelse 0);
                },
                // VT_BOOL.
                11 => {
                    const b: i16 = if (jbool(&entry.val) orelse false) -1 else 0;
                    @as(*align(1) i16, @ptrCast(dst)).* = b;
                },
                // VT_CY.
                6 => {
                    @as(*align(1) i64, @ptrCast(dst)).* = @intFromFloat((jf64(&entry.val) orelse 0) * 10000.0);
                },
                // VT_UI1.
                17 => {
                    dst[0] = @intCast(ji64(&entry.val) orelse 0);
                },
                // VT_DISPATCH: embedded Collection via {"$collection":
                // [...]} (iteration 22 — the series-grp config writers
                // take UDTs with Object-collection fields). The ref
                // transfers from the inputCollection VARIANT into the
                // record bytes; RecBox releases it after the invoke.
                26 => {
                    if (entry.val != .obj) continue;
                    const marker = entry.val.get("$collection") orelse continue;
                    if (marker.* != .arr) {
                        sess.setErr("$collection field '{s}' must be a JSON array", .{entry.key});
                        return error.BadArgs;
                    }
                    var field_recs: ?*marshal.RecBox = null;
                    const cv = marshal.inputCollection(sess, marker.arr, &field_recs) catch |icerr| {
                        marshal.freeRecChain(alloc, field_recs);
                        return icerr;
                    };
                    marshal.chainAppend(&coll_recs, field_recs);
                    const dsp: ?*win32.IDispatch = @ptrCast(@alignCast(cv.data.pdispVal));
                    @as(*align(1) ?*win32.IDispatch, @ptrCast(dst)).* = dsp;
                    if (dsp != null) try owned.append(alloc, .{ .off = f.off, .vt = 26 });
                },
                else => {}, // unsupported field type skipped
            }
        }
    }

    var out = VARIANT.init();
    // VB6 UDT-param shape (sweepable via BUSY_REC_SHAPE, iteration 19):
    // "byrefvar" (default/shipped) = VT_BYREF|VT_VARIANT -> inner
    // VT_RECORD; "byval" = bare VT_RECORD; "byrefrec" = VT_BYREF|VT_RECORD.
    // All three clean-0x80020005 on the CopyVchData discriminator until
    // a shape lands (probe report §19).
    const ri = try recordInfoFor(sess, ti_udt);
    switch (shapeFromEnv(alloc)) {
        .byval => {
            out.vt = win32.VT_RECORD;
            out.data.rec = .{ .pRecValue = buf.ptr, .pRecInfo = ri };
        },
        .byrefrec => {
            out.vt = win32.VT_BYREF | win32.VT_RECORD;
            out.data.rec = .{ .pRecValue = buf.ptr, .pRecInfo = ri };
        },
        .byrefvar => {
            const box = alloc.create(VARIANT) catch return error.OutOfMemory;
            box.* = VARIANT.init();
            box.vt = win32.VT_RECORD;
            box.data.rec = .{ .pRecValue = buf.ptr, .pRecInfo = ri };
            out.vt = win32.VT_BYREF | win32.VT_VARIANT;
            out.data.byref = box;
        },
    }
    out.r2 = @truncate(d.size); // cleanup size stash (u16)
    return .{ .variant = out, .owned = try owned.toOwnedSlice(alloc), .coll_recs = coll_recs };
}

/// Probe knob for the $record input shape (iteration 19): BUSY_REC_SHAPE
/// selects the VARIANT boxing — "byrefvar" (default, shipped shape)
/// VT_BYREF|VT_VARIANT→inner VT_RECORD, "byval" bare VT_RECORD, or
/// "byrefrec" VT_BYREF|VT_RECORD. Pure name mapping for tests.
pub const RecShape = enum { byval, byrefrec, byrefvar };
pub fn shapeFromName(s: []const u8) RecShape {
    if (std.mem.eql(u8, s, "byrefrec")) return .byrefrec;
    if (std.mem.eql(u8, s, "byrefvar")) return .byrefvar;
    return .byval;
}
pub fn shapeFromEnv(alloc: Allocator) RecShape {
    const own_env: std.process.Environ = .{ .block = .global };
    const v = own_env.getAlloc(alloc, "BUSY_REC_SHAPE") catch return .byval;
    defer alloc.free(v);
    return shapeFromName(v);
}

/// HREFTYPE-based entry (the proven path): {"$record":{htype,fields}}.
pub fn recordFromHreftype(
    sess: *Session,
    alloc: Allocator,
    hreftype: u32,
    fields: *const json.Value,
) !RecordInst {
    const d = sess.disp orelse return error.NoDispatch;
    var tc: u32 = 0;
    _ = d.vtbl.GetTypeInfoCount(d, &tc);
    if (tc == 0) return error.NoTypeInfo;
    var ti_main: ?*ITypeInfo = null;
    _ = d.vtbl.GetTypeInfo(d, 0, 0, &ti_main);
    const ti = ti_main orelse return error.NoTypeInfo;
    defer _ = ti.vtbl.Release(ti);
    var udt: ?*ITypeInfo = null;
    const hr = ti.vtbl.GetRefTypeInfo(ti, hreftype, &udt);
    const tudt = udt orelse {
        sess.setErr("GetRefTypeInfo({d}) failed 0x{x}", .{ hreftype, @as(u32, @bitCast(hr)) });
        return error.NotFound;
    };
    defer _ = tudt.vtbl.Release(tudt);
    return recordFromUdtTi(sess, alloc, tudt, hreftype, fields);
}

// ---------------- tests (pure) ----------------

const testing = std.testing;

test "shapeFromName maps the BUSY_REC_SHAPE sweep values" {
    try testing.expectEqual(RecShape.byval, shapeFromName(""));
    try testing.expectEqual(RecShape.byval, shapeFromName("bogus"));
    try testing.expectEqual(RecShape.byval, shapeFromName("byval"));
    try testing.expectEqual(RecShape.byrefrec, shapeFromName("byrefrec"));
    try testing.expectEqual(RecShape.byrefvar, shapeFromName("byrefvar"));
}

test "releaseOwned tolerates empty lists and unknown field vts" {
    // Fabricated buffer: only no-op entries (empty list; unknown vt
    // skipped) — the BSTR/DISPATCH paths need live COM (§22).
    var buf: [8]u8 = undefined;
    @memset(&buf, 0);
    releaseOwned(&buf, &.{});
    releaseOwned(&buf, &.{.{ .off = 0, .vt = 99 }});
}
