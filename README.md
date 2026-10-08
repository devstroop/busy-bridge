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
busy-bridge call --method M --args '[...]'      # any of ~4,400 COM methods
busy-bridge serve [--port 9820] [--comp C]      # HTTP JSON/XML API over the same ops
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
| `POST /query` | `{"sql":"..."}` | SQL against the open company |
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
