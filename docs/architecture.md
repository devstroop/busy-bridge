# Source architecture

How `busy-bridge/` source is organized, the conventions that keep it
healthy, and how to extend it. Enforced by the two structure gates
(`scripts/check_layers.ps1`, `scripts/check_size.ps1`) — see
[Development](../README.md#development).

## Folder map

```text
src/
├── main.zig              argv -> commands.run (imports transport only)
├── core/                 BUSY domain — never imports transport
│   ├── com.zig + com/    raw IDispatch FFI: Session, invoke, recordset, surface
│   ├── ops.zig           barrel + test-aggregation block for ops children
│   ├── ops/
│   │   ├── masters.zig   barrel (Kind, typeCode, ListOpts, requireStr)
│   │   │   ├── read.zig      list, get — normalized reads, keyset paging
│   │   │   └── write.zig     create, update, delete — SaveMasterFromXML
│   │   ├── vouchers.zig  barrel (ListOpts)
│   │   │   ├── read.zig      list, get — Tran1 + GetVchXML
│   │   │   └── write.zig     buildSale/JournalDoc, post, delete
│   │   ├── common.zig    barrel
│   │   │   ├── value.zig     put/objFrom/merge/dup/stringify/childStr
│   │   │   ├── sql.zig       resolveNames, codeByName, classProgId
│   │   │   ├── dates.zig     normalizeDate / toBusyDate
│   │   │   └── cursor.zig    opaque keyset paging cursors
│   │   ├── reports.zig   named reports (by design: one probe-verified
│   │   │                 call pattern each; see size-gate allowlist)
│   │   ├── exec.zig      write-op dispatcher (CLI + HTTP + batch share it)
│   │   ├── batch.zig     BeginTran/CommitTran batch runner
│   │   └── catalog.zig   op catalog as data (by design: pure table)
│   ├── constants.zig     master/voucher code tables (machine-readable)
│   ├── registry.zig      Win32 registry: newest Busy2L*.CFixedInterface
│   └── xmlmeta.zig       which methods carry XML docs (Get=out, Save=in)
├── transport/            protocol edge — may import core + util
│   ├── main dispatcher: commands.zig (CLI), http.zig (serve)
│   ├── commands/
│   │   ├── raw.zig       classes, surface, query, call
│   │   └── ops.zig       `op` verb dispatch, reports, writes
│   ├── http/
│   │   ├── shared.zig    ConnCtx/Route + envelope/mapping helpers
│   │   ├── routes_meta.zig   /health /surface /classes /info /constants
│   │   ├── routes_ops.zig    /op/*
│   │   └── routes_raw.zig    /query /call
│   ├── format.zig        barrel + THE zig-build-test aggregation root
│   │   ├── wire.zig          Format enum + Accept/--out negotiation
│   │   ├── call.zig          enrichCallResult / xmlifyArgs / passthrough
│   │   └── xml_envelopes.zig error/constants/info/health/classes/surface/
│   │                         rowset/call payload builders
│   ├── v1.zig            /v1 versioned resource facade + cursor paging
│   ├── sessions.zig      multi-company Switcher (issue #5)
│   ├── envelope.zig      JSON wire envelopes (ok/err/op/rows)
│   ├── auth.zig          token gate + safe-bind policy (issue #4)
│   └── cli.zig           argv parsing, Usage, option helpers
└── util/                 no BUSY knowledge, no transport knowledge
    ├── json.zig + json/   value model, parser, writer
    ├── xml.zig + xml/     parser/writer + mapping (fixtures-tested)
    ├── sqlguard.zig       query-mode guard (issue #3)
    └── helpers.zig        strings, base64, urlDecode, errCode, stdout
```

## Conventions

### Barrels (`foo.zig` + `foo/`)

A module split keeps its original file as a **barrel** that re-exports
every public name. Import paths (`ops.masters.list`, `common.put`) and
call sites never change; only the bodies move. Children may import the
barrel back for shared types — Zig resolves the lazy cycle (this is how
`masters/read.zig` reaches `m.typeCode` and `commands/raw.zig` reaches
`cmd.fail`).

### Test discovery

`zig build test` roots at `src/main.zig`; tests only run for files pulled
in from a **test block**. Two aggregation blocks cover the tree:

- `transport/format.zig` → `test "test aggregation for the build test root"` — util, core, envelope, auth, sessions, v1, format children
- `core/ops.zig` → `test "test aggregation for ops children"` — every `ops/*` module

**Any new file with tests must be referenced from one of these blocks**
or its tests silently never run (this bug hid 26 tests for months —
fixed in `b7d51d0`). After touching discovery-relevant files, verify by
*name*, not just count:

```powershell
$exe = Get-ChildItem .zig-cache -Recurse -Filter test.exe | Sort-Object LastWriteTime -Descending | Select-Object -First 1
& $exe.FullName   # "All N tests passed" + per-test names
```

### Route dispatch order (contract)

`http.zig` `route()` dispatches in a fixed order — each group returns
`null` to fall through (`!?Route`):

```text
company-ensure (?comp=/X-Company, issue #5)
  → routes_meta  →  /v1  →  routes_ops  →  routes_raw  →  404
```

`serve()`/`handleConn`/auth gate live only in `http.zig`; route groups
never touch sockets.

### How to add…

- **a raw CLI command**: `fn cmdX(...)` in `commands/raw.zig` (or
  `ops.zig` for `op` verbs), one `if` line in `commands.zig run()`.
- **an /op operation**: data row in `core/ops/catalog.zig` (docs +
  `GET /op` regenerate from it), handler in `core/ops/exec.zig` (writes)
  or the relevant `ops/*` module (reads), then the HTTP route in
  `http/routes_ops.zig` if it needs one.
- **a /v1 resource**: route arm in `v1.zig routeInner`, reusing
  `core/ops` — no new COM logic at the transport edge.
- **an HTTP route group**: new `http/routes_<name>.zig` returning
  `!?Route`, wired into `http.zig route()` at the right position.

## Structure gates

| Gate | Rule | Exemptions |
|---|---|---|
| `check_layers.ps1` | `util→util`, `core→+core`, `transport→+transport`, `main→transport` | none |
| `check_size.ps1` | `src/**/*.zig` ≤ 400 physical lines (warn > 300), `tests/**/*.ps1` ≤ 200; **enforce by default**, `-ReportOnly` to preview | allowlist entries need a written reason: `[by design]` permanent (catalog table, parser unit) or `[transitional]` tied to an open split phase (delete when it lands) |

History: the restructure that produced this layout is issue
[`011-source-restructure.md`](issues/011-source-restructure.md); the
repo-split decision record (COM lib vs server — deferred, triggers) is
in [`roadmap.md`](roadmap.md). The evidence file for the *next* split
into separate project(s) — self-containment audit, import matrix, test
distribution — is [`separation-readiness.md`](separation-readiness.md).
