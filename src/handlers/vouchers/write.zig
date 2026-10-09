//! ERP voucher writes (issue #7 M2 / 011 phase 1b): structured sale/
//! journal document builders + raw doc passthrough over SaveVchFromXML,
//! and delete. Shared helpers (byrefArg/requireStr/docToXml) come from
//! the masters barrel; reads live in `read.zig`.
const std = @import("std");
const json = @import("../../util/json.zig");
const constants = @import("../../core/constants.zig");
const com = @import("../../core/com.zig");
const common = @import("../common.zig");
const masters = @import("../masters.zig");

const Allocator = std.mem.Allocator;
const Session = com.Session;

const byrefArg = masters.byrefArg;
const requireStr = masters.requireStr;
const docToXml = masters.docToXml;

fn num(v: *const json.Value) ?f64 {
    return switch (v.*) {
        .int => |i| @floatFromInt(i),
        .float => |f| f,
        .str => |s| std.fmt.parseFloat(f64, std.mem.trim(u8, s, " ")) catch null,
        else => null,
    };
}

fn optText(alloc: Allocator, req: *const json.Value, key: []const u8) !?[]u8 {
    if (req.* != .obj) return null;
    const v = req.get(key) orelse return null;
    return switch (v.*) {
        .str => |s| try alloc.dupe(u8, s),
        .int => |i| try std.fmt.allocPrint(alloc, "{d}", .{i}),
        .float => |f| try std.fmt.allocPrint(alloc, "{d}", .{f}),
        else => null,
    };
}

/// Structured SALE document (recipe proven live in tests 04/06):
/// series/date/type/[no]/stpt/party/[store] + ItemEntries. ST fields are
/// sent as 0 (the tested exempt path — taxed documents go via `doc`).
pub fn buildSaleDoc(sess: *Session, alloc: Allocator, req: *const json.Value) !json.Value {
    const series = (try optText(alloc, req, "series")) orelse try alloc.dupe(u8, "Main");
    defer alloc.free(series);
    const stpt = try requireStr(sess, req, "stpt", "post sale requires \"stpt\" (e.g. \"Local-Exempt\")");
    const party = try requireStr(sess, req, "party", "post sale requires \"party\" (account name)");
    const store = try optText(alloc, req, "store");
    defer if (store) |s| alloc.free(s);
    const no = try optText(alloc, req, "no");

    const lines_v = if (req.* == .obj) req.get("lines") else null;
    if (lines_v == null or lines_v.?.* != .arr or lines_v.?.arr.len == 0) {
        sess.setErr("post sale requires \"lines\": [{{item, qty, price?, amt?, unit?, store?}}]", .{});
        return error.BadArgs;
    }
    const lines = lines_v.?.arr;

    var items: std.ArrayList(json.Value) = .empty;
    defer {
        for (items.items) |*v| v.deinit(alloc);
        items.deinit(alloc);
    }
    for (lines, 0..) |*ln, idx| {
        if (ln.* != .obj) {
            sess.setErr("post sale: lines[{d}] must be an object", .{idx});
            return error.BadArgs;
        }
        const item = try requireStr(sess, ln, "item", "each sale line requires \"item\"");
        const qty = if (ln.get("qty")) |q| num(q) else null;
        if (qty == null) {
            sess.setErr("post sale: lines[{d}] requires numeric \"qty\"", .{idx});
            return error.BadArgs;
        }
        const price = if (ln.get("price")) |p| num(p) else null;
        var amt = if (ln.get("amt")) |a| num(a) else null;
        if (amt == null) amt = if (price) |p| p * qty.? else 0;
        if (price == null and ln.get("amt") == null) {
            sess.setErr("post sale: lines[{d}] requires \"price\" or \"amt\"", .{idx});
            return error.BadArgs;
        }
        const unit = if (ln.* == .obj) if (ln.get("unit")) |u| (if (u.* == .str) u.str else null) else null else null;
        const line_store = if (ln.get("store")) |st| (if (st.* == .str) st.str else null) else store;

        var e: std.ArrayList(json.Value.Entry) = .empty;
        try common.put(alloc, &e, "SrNo", .{ .int = @intCast(idx + 1) });
        try common.put(alloc, &e, "ItemName", .{ .str = try alloc.dupe(u8, item) });
        if (unit) |u| try common.put(alloc, &e, "UnitName", .{ .str = try alloc.dupe(u8, u) });
        try common.put(alloc, &e, "Qty", .{ .float = qty.? });
        try common.put(alloc, &e, "Price", .{ .float = price orelse 0 });
        try common.put(alloc, &e, "Amt", .{ .float = amt.? });
        try common.put(alloc, &e, "STAmount", .{ .float = 0 });
        try common.put(alloc, &e, "STPercent", .{ .float = 0 });
        try common.put(alloc, &e, "TaxBeforeSurcharge", .{ .float = 0 });
        if (line_store) |ms| try common.put(alloc, &e, "MC", .{ .str = try alloc.dupe(u8, ms) });
        try items.append(alloc, try common.objFrom(alloc, &e));
    }

    var root: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &root, "VchSeriesName", .{ .str = try alloc.dupe(u8, series) });
    {
        const d = try requireStr(sess, req, "date", "post voucher requires \"date\" (YYYY-MM-DD)");
        const busy_d = (try common.toBusyDate(alloc, d)) orelse {
            sess.setErr("invalid \"date\" '{s}' (expected YYYY-MM-DD)", .{d});
            return error.BadArgs;
        };
        // owned by the document (no free — doc_val.deinit releases it)
        try common.put(alloc, &root, "Date", .{ .str = busy_d });
    }
    try common.put(alloc, &root, "VchType", .{ .int = constants.voucherCode("SALE").? });
    if (no) |n| {
        // owned by the document (no free — doc_val.deinit releases it)
        try common.put(alloc, &root, "VchNo", .{ .str = n });
    }
    try common.put(alloc, &root, "STPTName", .{ .str = try alloc.dupe(u8, stpt) });
    try common.put(alloc, &root, "MasterName1", .{ .str = try alloc.dupe(u8, party) });
    if (store) |s| try common.put(alloc, &root, "MasterName2", .{ .str = try alloc.dupe(u8, s) });
    var entries: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &entries, "ItemDetail", .{ .arr = try items.toOwnedSlice(alloc) });
    try common.put(alloc, &root, "ItemEntries", try common.objFrom(alloc, &entries));
    var doc: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &doc, "Sale", try common.objFrom(alloc, &root));
    return common.objFrom(alloc, &doc);
}

/// Structured JOURNAL document (vendor template shape):
/// entries: [{account, amount, dr}] with debit/credit balance checked
/// before BUSY sees it (AmountType 1=Dr, 2=Cr per the vendor sample).
pub fn buildJournalDoc(sess: *Session, alloc: Allocator, req: *const json.Value) !json.Value {
    const series = (try optText(alloc, req, "series")) orelse try alloc.dupe(u8, "Main");
    defer alloc.free(series);
    const entries_v = if (req.* == .obj) req.get("entries") else null;
    if (entries_v == null or entries_v.?.* != .arr or entries_v.?.arr.len == 0) {
        sess.setErr("post journal requires \"entries\": [{{account, amount, dr}}]", .{});
        return error.BadArgs;
    }
    const entries_in = entries_v.?.arr;

    var details: std.ArrayList(json.Value) = .empty;
    defer {
        for (details.items) |*v| v.deinit(alloc);
        details.deinit(alloc);
    }
    var dr_sum: f64 = 0;
    var cr_sum: f64 = 0;
    for (entries_in, 0..) |*en, idx| {
        if (en.* != .obj) {
            sess.setErr("post journal: entries[{d}] must be an object", .{idx});
            return error.BadArgs;
        }
        const acct = try requireStr(sess, en, "account", "each journal entry requires \"account\"");
        const amt = if (en.get("amount")) |a| num(a) else null;
        if (amt == null or amt.? <= 0) {
            sess.setErr("post journal: entries[{d}] requires numeric \"amount\" > 0", .{idx});
            return error.BadArgs;
        }
        const dr: bool = if (en.get("dr")) |d| (d.* == .bool and d.bool) else false;
        if (dr) dr_sum += amt.? else cr_sum += amt.?;

        var e: std.ArrayList(json.Value.Entry) = .empty;
        try common.put(alloc, &e, "SrNo", .{ .int = @intCast(idx + 1) });
        try common.put(alloc, &e, "AccountName", .{ .str = try alloc.dupe(u8, acct) });
        try common.put(alloc, &e, "AmountType", .{ .int = if (dr) 1 else 2 });
        try common.put(alloc, &e, "AmtMainCur", .{ .float = amt.? });
        try details.append(alloc, try common.objFrom(alloc, &e));
    }
    const eps = 0.005;
    if (@abs(dr_sum - cr_sum) >= eps) {
        sess.setErr("journal entries do not balance (debit {d}, credit {d})", .{ dr_sum, cr_sum });
        return error.BadArgs;
    }

    var root: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &root, "VchSeriesName", .{ .str = try alloc.dupe(u8, series) });
    {
        const d = try requireStr(sess, req, "date", "post voucher requires \"date\" (YYYY-MM-DD)");
        const busy_d = (try common.toBusyDate(alloc, d)) orelse {
            sess.setErr("invalid \"date\" '{s}' (expected YYYY-MM-DD)", .{d});
            return error.BadArgs;
        };
        // owned by the document (no free — doc_val.deinit releases it)
        try common.put(alloc, &root, "Date", .{ .str = busy_d });
    }
    try common.put(alloc, &root, "VchType", .{ .int = constants.voucherCode("JOURNAL").? });
    if (try optText(alloc, req, "no")) |n| {
        // owned by the document (no free — doc_val.deinit releases it)
        try common.put(alloc, &root, "VchNo", .{ .str = n });
    }
    var accs: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &accs, "AccDetail", .{ .arr = try details.toOwnedSlice(alloc) });
    try common.put(alloc, &root, "AccEntries", try common.objFrom(alloc, &accs));
    var doc: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &doc, "Journal", try common.objFrom(alloc, &root));
    return common.objFrom(alloc, &doc);
}

/// Post a voucher: structured `sale`/`journal` requests or a raw `doc`
/// passthrough for any other type. Returns the new VchCode (ByRef from
/// SaveVchFromXML; probe-verified 6-arg form).
pub fn post(sess: *Session, alloc: Allocator, req: *const json.Value) !json.Value {
    const type_name = try requireStr(sess, req, "type", "post voucher requires \"type\" (canonical name, e.g. \"sale\")");
    const vt = constants.voucherCode(type_name) orelse {
        sess.setErr("unknown voucher type '{s}' (see GET /constants)", .{type_name});
        return error.BadArgs;
    };

    // raw document passthrough (escape hatch for any type)
    if (req.* == .obj) if (req.get("doc")) |dv| {
        if (dv.* != .obj or dv.obj.len != 1) {
            sess.setErr("\"doc\" must be a single-key document object like {{\"Payment\":{{...}}}}", .{});
            return error.BadArgs;
        }
        const xml_text = try docToXml(alloc, dv);
        defer alloc.free(xml_text);
        const vch_code = try saveVch(sess, alloc, vt, xml_text);
        return postResult(sess, alloc, vt, req, vch_code, null);
    };

    const canonical = constants.voucherName(vt) orelse "";
    var doc_val = if (std.mem.eql(u8, canonical, "SALE"))
        try buildSaleDoc(sess, alloc, req)
    else if (std.mem.eql(u8, canonical, "JOURNAL"))
        try buildJournalDoc(sess, alloc, req)
    else {
        sess.setErr("structured post supports sale|journal — pass \"doc\":{{\"Root\":{{...}}}} for '{s}'", .{type_name});
        return error.BadArgs;
    };
    defer doc_val.deinit(alloc);
    const xml_text = try docToXml(alloc, &doc_val);
    defer alloc.free(xml_text);
    const vch_code = try saveVch(sess, alloc, vt, xml_text);

    var date_iso: ?[]u8 = null;
    if (req.* == .obj) if (req.get("date")) |d| {
        if (d.* == .str) date_iso = try common.normalizeDate(alloc, d.str);
    };
    defer if (date_iso) |x| alloc.free(x);
    return postResult(sess, alloc, vt, req, vch_code, date_iso);
}

/// SaveVchFromXML 6-arg ByRef form:
/// `[type, xml, $err, false, 0, $code]` -> `outs = [err, vchCode]`
/// (probe-verified via PowerShell A2 + bisection on p_Source).
fn saveVch(sess: *Session, alloc: Allocator, vt: i64, xml_text: []const u8) !i64 {
    var e1 = try byrefArg(alloc);
    defer e1.deinit(alloc);
    var e2 = try byrefArg(alloc);
    defer e2.deinit(alloc);
    var args = [_]json.Value{
        .{ .int = vt },
        .{ .str = xml_text },
        e1,
        .{ .bool = false },
        .{ .int = 0 }, // p_ModifyKey (unused when modify=false)
        e2,
    };
    var r = try sess.invoke("SaveVchFromXML", &args);
    defer r.deinit(sess.alloc);
    if (!(r.ret == .bool and r.ret.bool)) {
        const m: []const u8 = if (r.outs.len > 0 and r.outs[0] == .str and r.outs[0].str.len > 0)
            r.outs[0].str
        else
            "SaveVchFromXML rejected the document";
        sess.setErr("{s}", .{m});
        return error.BusyRejected;
    }
    if (r.outs.len > 1 and r.outs[1] == .int) return r.outs[1].int;
    return 0;
}

fn postResult(sess: *Session, alloc: Allocator, vt: i64, req: *const json.Value, code: i64, date_iso: ?[]const u8) !json.Value {
    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, "voucher") });
    try common.put(alloc, &out, "code", .{ .int = code });
    try common.put(alloc, &out, "posted", .{ .bool = true });
    var te: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &te, "code", .{ .int = vt });
    if (constants.voucherName(vt)) |tn| try common.put(alloc, &te, "name", .{ .str = try alloc.dupe(u8, tn) });
    try common.put(alloc, &out, "type", try common.objFrom(alloc, &te));
    if (req.* == .obj) {
        if (try optText(alloc, req, "no")) |n| {
            // owned by the result object (res.deinit releases it)
            try common.put(alloc, &out, "no", .{ .str = n });
        }
    }
    if (date_iso) |d| try common.put(alloc, &out, "date", .{ .str = try alloc.dupe(u8, d) });
    _ = sess;
    return common.objFrom(alloc, &out);
}

/// Delete a voucher by code: `{code, deleted:true}`.
pub fn delete(sess: *Session, alloc: Allocator, code: i64) !json.Value {
    var e = try byrefArg(alloc);
    defer e.deinit(alloc);
    var args = [_]json.Value{ .{ .int = code }, e };
    var r = try sess.invoke("DeleteVchByCode", &args);
    defer r.deinit(sess.alloc);
    if (!(r.ret == .bool and r.ret.bool)) {
        const m: []const u8 = if (r.outs.len > 0 and r.outs[0] == .str and r.outs[0].str.len > 0)
            r.outs[0].str
        else
            "DeleteVchByCode rejected";
        sess.setErr("{s}", .{m});
        return error.BusyRejected;
    }
    var out: std.ArrayList(json.Value.Entry) = .empty;
    try common.put(alloc, &out, "kind", .{ .str = try alloc.dupe(u8, "voucher") });
    try common.put(alloc, &out, "code", .{ .int = code });
    try common.put(alloc, &out, "deleted", .{ .bool = true });
    return common.objFrom(alloc, &out);
}

// ---------------- tests (pure) ----------------

const testing = std.testing;

test "buildJournalDoc balance validation + shape" {
    const a = testing.allocator;
    var sess = try Session.init(a);
    defer sess.deinit();

    var ok_req = try json.parse(a,
        \\{"type":"journal","date":"2026-10-08","entries":[
        \\ {"account":"Depreciation A/c","amount":500,"dr":true},
        \\ {"account":"Cash","amount":500}]}
    );
    defer ok_req.deinit(a);
    var doc = try buildJournalDoc(&sess, a, &ok_req);
    defer doc.deinit(a);
    const xml_text = try docToXml(a, &doc);
    defer a.free(xml_text);
    try testing.expect(std.mem.indexOf(u8, xml_text, "<Journal>") == 0);
    try testing.expect(std.mem.indexOf(u8, xml_text, "<AmountType>1</AmountType>") != null); // dr
    try testing.expect(std.mem.indexOf(u8, xml_text, "<AmountType>2</AmountType>") != null); // cr default
    try testing.expect(std.mem.indexOf(u8, xml_text, "<Date>08-10-2026</Date>") != null); // write format
    try testing.expect(std.mem.indexOf(u8, xml_text, "<VchType>16</VchType>") != null);
    try testing.expect(std.mem.indexOf(u8, xml_text, "<AccountName>Cash</AccountName>") != null);

    // unbalanced -> BadArgs with a precise session message
    var bad = try json.parse(a,
        \\{"type":"journal","date":"2026-10-08","entries":[
        \\ {"account":"Cash","amount":500,"dr":true},
        \\ {"account":"Sales","amount":400}]}
    );
    defer bad.deinit(a);
    try testing.expectError(error.BadArgs, buildJournalDoc(&sess, a, &bad));
    try testing.expect(std.mem.indexOf(u8, sess.lastError(), "do not balance") != null);
}

test "buildSaleDoc shape and required fields" {
    const a = testing.allocator;
    var sess = try Session.init(a);
    defer sess.deinit();

    var req = try json.parse(a,
        \\{"type":"sale","date":"2026-10-08","series":"ZigVch9","no":"910",
        \\ "stpt":"Local-Exempt","party":"Busy Infotech Pvt. Ltd.","store":"Main Store",
        \\ "lines":[{"item":"ZigItem","qty":2,"price":100}]}
    );
    defer req.deinit(a);
    var doc = try buildSaleDoc(&sess, a, &req);
    defer doc.deinit(a);
    const xml_text = try docToXml(a, &doc);
    defer a.free(xml_text);
    try testing.expect(std.mem.indexOf(u8, xml_text, "<Sale>") == 0);
    try testing.expect(std.mem.indexOf(u8, xml_text, "<VchSeriesName>ZigVch9</VchSeriesName>") != null);
    try testing.expect(std.mem.indexOf(u8, xml_text, "<VchNo>910</VchNo>") != null);
    try testing.expect(std.mem.indexOf(u8, xml_text, "<Amt>200</Amt>") != null); // qty*price default
    try testing.expect(std.mem.indexOf(u8, xml_text, "<MC>Main Store</MC>") != null); // store -> MC default
    try testing.expect(std.mem.indexOf(u8, xml_text, "<MasterName1>Busy Infotech Pvt. Ltd.</MasterName1>") != null);

    // missing stpt -> precise BadArgs
    var no_stpt = try json.parse(a,
        \\{"type":"sale","date":"2026-10-08","party":"X",
        \\ "lines":[{"item":"I","qty":1,"price":1}]}
    );
    defer no_stpt.deinit(a);
    try testing.expectError(error.BadArgs, buildSaleDoc(&sess, a, &no_stpt));
    try testing.expect(std.mem.indexOf(u8, sess.lastError(), "stpt") != null);
}
