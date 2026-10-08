# busy-bridge

A modern, programmatic interface over **BUSY ERP**'s COM API surface — a
single binary exposing every registered BUSY class as **JSON** (default) or
**pure XML**, over a CLI and a local HTTP server.

Built for BUSY Accounting Software **Rel 14** (32-bit COM; validated live
against a DEMO company), Zig 0.17, zero runtime dependencies.

```text
busy-bridge classes                            # all registered Busy* COM ProgIDs (925 on Rel 14)
busy-bridge surface [--prog-id P] [--member M] # full IDispatch surface of a class
busy-bridge query --comp COMP0001 --sql "..."   # SQL -> rows (opens company via OpenDB)
      [--query-mode full|read-only|off]        # query guard (default: full; see "Query safety")
      [--max-rows N]                           # row cap (default 10000; 0 = unlimited)
busy-bridge call --method M --args '[...]'      # any of ~4,400 COM methods
busy-bridge serve [--port 9820] [--comp C]      # HTTP JSON/XML API over the same ops
      [--query-mode ...] [--max-rows N]         # serve defaults to read-only / 10000
```

## Wire contract: one format per response

Every response is **either pure JSON or pure XML — never a mixture**.

| | JSON (default) | XML |
|---|---|---|
| CLI | `--out json` | `--out xml` |
| HTTP response | default / `Accept: application/json` | `Accept: application/xml` (or `text/xml`) |
| HTTP request body | JSON (default) | `Content-Type: application/xml` (raw BUSY document, see below) |

`version`/`help` are always plain text. `serve` ignores `--out` — it
negotiates **per request** via `Accept`.

### JSON mode (default)

Two rules keep XML out of the consumer's way:

1. **Results are structured, never blobs.** Methods whose name contains
   `XML` and starts with `Get` return their document parsed into a JSON
   tree:

   ```json
   {"ok":true,"result":{"Company":{"CompanyName":"DEMO","State":"Delhi", ...}},"outs":[]}
   ```

2. **Arguments accept document objects.** For methods that take a document
   (`Save*/Add*/Modify*XML`, the doc is `args[1]`), pass a **single-key
   document object**; the bridge serializes BUSY's XML before the COM call:

   ```powershell
   $a = '[2, {"Account":{"Name":"X", ...}}, {"$byref":""}, false]'
   $b64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($a))
   busy-bridge call --comp COMP0001 --method SaveMasterFromXML --args-b64 $b64
   # --args is fine from shells that don't mangle quotes; PowerShell 5.1 needs --args-b64
   ```

   A raw XML **string** at that position is passed through unchanged
   (backward compatible with existing scripts).

### XML mode

| Operation | Response shape |
|---|---|
| `query` | **ADO rowset XML** — same structure as the legacy web service (`SC=1`) on port 981, so consumers migrating from BUSY's old HTTP interface keep parsing the same document |
| `Get*XML` methods | **raw passthrough**, byte-identical to BUSY's output |
| `classes` | `<Classes count='925'><Class>...</Class></Classes>` |
| `surface` | `<Surface prog_id='...' count='N'><Member name kind nparams nopt><Param>...</Param></Member></Surface>` |
| `call` (other) | `<Call method='...'><Result>true</Result><Outs><Out>...</Out></Outs></Call>` |
| `serve /health` | `<Health status='up'/>` |
| any failure | `<Error code='…' error='…'>message</Error>` — `code` = exit code (CLI) / HTTP status; `error` = stable machine code (`no_recordset`, `not_found`, …) |

Empty values serialize as self-closing tags (`<Result/>`), matching BUSY's
own style.

### XML ↔ JSON mapping conventions

| XML | JSON |
|---|---|
| `<Name>Cash</Name>` | `{"Name":"Cash"}` — text stays a **string**, numbers are never coerced (lossless) |
| empty / `<X/>` | `null` |
| repeated siblings | array, **first-appearance key order** preserved |
| attributes | `"@name"` keys |
| mixed text + elements | `"$text"` key |

The parser handles the well-formed subset BUSY actually emits (verified
against five captured fixtures in `src/util/xml/testdata/`: element-only,
`&amp;/&lt;/&gt;` entities, self-closing tags, no declaration/BOM) and
tolerates attributes, CDATA, comments, PIs and DOCTYPE skips defensively.

## HTTP API

Base: `http://127.0.0.1:9820` (loopback by default; `--host` to change).

| Route | Request | Notes |
|---|---|---|
| `GET /health` | — | liveness |
| `GET /info` | — | bridge version, resolved ProgID, open company, formats, routes |
| `GET /constants` | — | canonical master/voucher code tables as data |
| `GET /classes` | — | registered `Busy*` ProgIDs |
| `GET /surface[?member=M]` | — | IDispatch surface of the active `--prog-id` |
| `POST /query` | `{"sql":"..."}` | SQL against the open company — **guarded**: read-only by default (see [Query safety](#query-safety-guarded-query)) |
| `POST /call` | `{"method":"M","args":[...]}` | any COM method |
| `GET /call?method=M&args=...` | `args` = URL-encoded JSON array | read-style calls, e.g. `args=%5Bfalse%5D` |
| `POST /call?method=M&type=N[&modify=true]` | **raw XML body** (`Content-Type: application/xml`) | document writes; `type` is the master/voucher type code at `args[0]` |

Errors are `<Error code='400|500' error='…'>` or
`{"ok":false,"code":"…","error":"…"}` with matching HTTP status. `code` is
the HTTP/exit status; `error` is a stable machine code (`bad_args`,
`invalid_json`, `invalid_xml_body`, `no_recordset`, `busy_not_found`,
`invoke_failed`, `not_found`, …) safe to branch on.

### Example

```powershell
# pure XML round-trip against a live company
Invoke-WebRequest "$base/query" -Method Post -Body '{"sql":"SELECT TOP 2 Code, Name FROM Master1"}' `
    -ContentType 'application/json' -Headers @{Accept='application/xml'}
# -> <?xml-less ADO rowset: <xml xmlns:s='uuid:...'><s:Schema>...<rs:data><z:row Code='1' Name='Cash'/>...

Invoke-WebRequest "$base/call?method=SaveMasterFromXML&type=2" -Method Post -Body $doc `
    -ContentType 'application/xml' -Headers @{Accept='application/xml'}
# -> <Call method='SaveMasterFromXML'><Result>true</Result>...
```

## Query safety (guarded query)

`query` and `POST /query` run SQL against the company database — the guard
keeps a remote/agent-driven caller from treating that as an open door
(issue #3):

| flag | values | default |
|---|---|---|
| `--query-mode` | `full` — any SQL runs · `read-only` — a single `SELECT`/`WITH` statement only · `off` — the query facility refuses everything | `full` for CLI `query`, **`read-only` for `serve`** |
| `--max-rows` | row cap on the response; `0` = unlimited | `10000` |

- **Refusals use the standard error envelope** with the stable machine
  code `"query_not_allowed"`: HTTP **403**, CLI exit **1**. `off` refuses
  before the body is even parsed (the route is disabled, not broken).
- `read-only` is **parser-light**: first keyword (`SELECT`/`WITH`, after
  whitespace/comments) plus a statement-boundary scan — it rejects
  `DELETE/UPDATE/DROP/EXEC/...` and multi-statement input like
  `SELECT 1; DROP TABLE x`, while `SELECT ';'`, `-- comments` and a single
  trailing `;` pass. This is a **guardrail, not a SQL firewall**: real
  isolation means read-only database credentials.
- **Capped responses** append `"truncated":true` (JSON) when rows were
  dropped; uncapped responses keep the exact original shape. XML-mode
  rowsets are capped too, but the legacy `SC=1` shape has no truncation
  marker — JSON is the truncation-aware mode.
- The boot line of `serve` reports the active policy:
  `{"ok":true,...,"query_mode":"read-only","max_rows":10000}`.
- **Scope**: the guard covers the query facility only. `call` / `POST
  /call` stays the raw COM escape hatch by design (raw = keep, facade =
  product — see [docs/roadmap.md](docs/roadmap.md)); remote exposure,
  auth and multi-tenant policy are tracked in issue #4. The future MCP
  server's query tool runs `read-only` unconditionally (issue #8).

```powershell
# refused everywhere except full mode:
busy-bridge query --query-mode read-only --sql "DELETE FROM Master1"
# {"ok":false,"code":"query_not_allowed","error":"read-only mode accepts only..."}
```

## Operations API

The normalized, ERP-centric **read** surface (facade M1, issue #7) —
business keys in, codes + names out, all COM/XML mechanics internal. Raw
`call`/`query` remain untouched as the escape hatch.

| | |
|---|---|
| CLI (reads) | `busy-bridge op catalog` · `op list accounts\|items\|vouchers [--limit N] [--q X] [--type NAME]` · `op get account\|item <name>` / `op get voucher <code>` |
| CLI (writes) | `op create\|update <account\|item> <name> --json '{..}'` · `op delete <account\|item> <name>` / `op delete voucher <code>` · `op post --json '{..}'` · `op batch --json '[..]'` (`--json-b64` for PowerShell) |
| HTTP (reads) | `GET /op` (catalog) · `/op/accounts[?limit=&q=]` `/op/account?name=` · `/op/items[?limit=&q=]` `/op/item?name=` · `/op/vouchers[?type=&limit=]` `/op/voucher?code=` |
| HTTP (writes) | `POST /op/account` · `PUT /op/account?name=` · `DELETE /op/account?name=` (item routes identical) · `POST /op/voucher` · `DELETE /op/voucher?code=` · `POST /op/batch` |

- **Envelopes** (both formats, both transports): JSON
  `{"ok":true,"op":"list-accounts","result":{…}}` — same shape as
  `call`; XML `<Op><name>…</name><result>…</result></Op>` via
  `--out xml` / `Accept: application/xml`.
- **Normalized rows**: list ops return `{code, name,
  parent:{code,name}}` (parent/group names batch-resolved), vouchers add
  `type:{code,name}` (constants table), `series`/`party` (Master1
  lookups) and `date` in ISO `YYYY-MM-DD`. Fetch ops add `doc` — the
  full BUSY document as a JSON tree, never an XML blob.
- **Parameters**: `limit` (default 100, `0` = unlimited, response gets
  `"truncated":true` when capped), `q` = case-insensitive name substring
  (client-side — BUSY's `LIKE` silently returns empty), `type` =
  canonical voucher name (`sale`, case-insensitive), `name` = exact
  business key, `code` = integer VchCode.
- **Errors**: `not_found` (HTTP 404 / exit 1), `bad_args` (400 / 1),
  `busy_rejected` (422 — BUSY's own verdict, e.g. *Invalid voucher
  series*), `batch_rolled_back` (422 — which entry broke and why), all
  with session-level messages; unknown voucher types point at
  `GET /constants`.
- **Writes are mechanical inside**: `create` builds the minimal document
  (`<Account><Name/><ParentGroup/>`); `update` fetches the **full**
  existing document, merges only the requested fields and re-saves with
  `modify=true` — untouched BUSY fields are never wiped; `post` offers
  structured builders for `sale` and `journal` (plus a raw `doc`
  single-key passthrough for any other type) and reads back the new
  VchCode from `SaveVchFromXML`'s ByRef out-param. Dates go
  `YYYY-MM-DD` in, `DD-MM-YYYY` on the wire, ISO out.
- **Batch = real transactions**: `POST /op/batch` / `op batch` run write
  entries inside `BeginTran`/`CommitTran` on **COtherServices** (the
  bridge auto-opens the company through a transient fixed-interface
  session — services classes share in-process state, probe-verified).
  Any failure calls `RollBackTran` and reports `op[N] '<op>': <reason>`;
  read ops are rejected as batch entries.
- **Catalog**: [docs/operations.md](docs/operations.md) — generated from
  the single source table in `src/core/ops/catalog.zig` by
  `scripts/docs/generate-ops-doc.ps1` (same table serves `op catalog`
  and `GET /op`).

Status: **M1 (reads) + M2 (writes: master CRUD, voucher posts, batch
transactions) shipped** — M3 (named reports) follows per
[issue #7](https://github.com/devstroop/busy-bridge/issues/7)
and [the RFC](docs/erp-operations-layer.md).

## Architecture

```text
src/
├── main.zig            argv collection + dispatch (imports transport only)
├── transport/          protocol concerns
│   ├── commands.zig      CLI commands, --out threading
│   ├── http.zig          server, negotiation, routing
│   ├── format.zig        Format enum, Accept/Content-Type parsing, XML builders
│   ├── envelope.zig      JSON envelope shaping
│   └── cli.zig           usage, defaults, option -> OpenOpts
├── core/               BUSY domain (never imports transport)
│   ├── com.zig + com/    raw IDispatch FFI, Session, surface/invoke/recordset
│   ├── ops.zig           openSession, surfaceText, OpenOpts
│   ├── xmlmeta.zig       which methods carry XML documents (Get=out, Save/Add/Modify=in@args[1])
│   └── registry.zig      Win32 registry enumeration
└── util/               no BUSY knowledge, no transport knowledge
    ├── json.zig + json/  JSON value/writer/parser
    ├── xml.zig + xml/    XML parser/writer + mapping (fixtures-tested)
    └── helpers.zig       strings, base64, urlDecode, stdout
```

Dependency direction is **enforced**: `scripts/check_layers.ps1` resolves
every `@import` against the layer rules (`util→util`, `core→+core`,
`transport→+transport`, `main→transport`) and fails the build in CI.

## Documentation & examples

- **[`docs/`](docs/)** — BUSY integration knowledge base, migrated from the
  original 2017 Word/Excel document set and updated for Rel 14 (guides +
  full [`docs/archive/`](docs/archive/) + generated
  [`docs/function-reference.md`](docs/function-reference.md))
- **[`examples/`](examples/)** — original sample scripts: VBScript reports
  & validations (`.bcr`/`.bcd`), VB6 Internal AddOn, COM samples (VB6 /
  VB.NET), legacy port-981 client

## Development

```powershell
zig build            # build x86-windows-gnu (32-bit: BUSY COM is 32-bit only)
zig build test       #29 unit tests (XML codec fidelity, negotiation, envelopes, xmlify)
zig fmt --check .    # formatting
powershell scripts/check_layers.ps1   # layer boundaries
```

CI (GitHub Actions, ubuntu + windows): fmt → layer check → build → unit
tests (Windows runner; test binary is x86-windows).

Live-BUSY tests (require BUSY + a company; **not** runnable in CI):

```powershell
powershell -File tests/live/run-all.ps1      # all three suites
powershell -File tests/live/01-roundtrip.ps1 # master create/read/delete (JSON)
powershell -File tests/live/02-serve-defaults.ps1   # HTTP JSON defaults
powershell -File tests/live/03-wire-modes.ps1       # both formats x both transports
```

Shared harness in `tests/live/common.ps1` (bridge path auto-resolved from
the repo; override with `$env:BUSY_BRIDGE_EXE` / `$env:BUSY_COMP`).

## Compatibility

- **Legacy port-981 web service**: XML-mode `query` responses deliberately
  mirror its `SC=1` rowset shape; `SC=1..9` was the full legacy surface.
- **Old sample code** (`CreateObject("Busy2L17.CFixedInterface")`) maps to
  `Busy2L21.CFixedInterface` — the bridge **auto-discovers** the newest
  registered `Busy2L*.CFixedInterface` from the registry (no hardcoding);
  `--prog-id` overrides, and `busy-bridge classes` lists them all.
- **Bitness**: all BUSY COM servers are 32-bit; the bridge is built x86.
 64-bit clients should use `busy-bridge serve`.
- **Safety**: never open the same company concurrently in the BUSY GUI and
  a headless bridge session (file-lock contention crashes BUSY).
