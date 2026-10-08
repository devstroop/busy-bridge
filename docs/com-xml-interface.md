# COM / XML interface (BUSY DLL integration)

> Migrated from *Integration using BUSY DLL.doc* (+ the function catalog in
> *BUSY Functions.docx*), corrected and extended against live Rel 14.

The primary integration channel: a **late-bound COM object** of BUSY's
`CFixedInterface` class. No DLL reference is required in your project —
BUSY's installation registers the ActiveX server (`C:\BusyWin\SYSTEM\`
32-bit). Data is exchanged as **BUSY-predefined XML documents** and **SQL
queries** returning DAO recordsets.

## Entry point

```
old docs (2017):  CreateObject("Busy2L17.CFixedInterface")
Rel 14:           CreateObject("Busy2L21.CFixedInterface")
```

The ProgID is **version-suffixed** — never hardcode it across upgrades.
Discover it at runtime (try `Busy2L<yy>` suffixes) or list what is
installed:

```powershell
busy-bridge classes          # all registered Busy* ProgIDs (925 on Rel 14)
busy-bridge surface          # full IDispatch surface of the default class
```

Via busy-bridge the version handling disappears entirely: the bridge
**auto-discovers the newest registered ProgID at startup** (registry scan —
`--prog-id` overrides; nothing registered fails fast with
`code:'busy_not_found'`).

**Bitness:** all BUSY COM servers are 32-bit. Any direct COM caller must be
32-bit (our bridge builds `x86-windows-gnu`). 64-bit clients should call
`busy-bridge serve` over HTTP instead.

## Opening a company

| Mode | Signature (Rel 14 live type info) | Notes |
|---|---|---|
| Access-style file storage | `OpenDB(p_BusyPath, p_DataPath, p_CompCode, p_FY)` | old docs showed 3 params; a 4th (`p_FY`) exists — passing 3 still works (late binding) |
| SQL Server | `OpenCSDB(p_BusyPath, p_ServerName, p_UserName, p_Pwd, p_CompCode)` | unchanged from old docs |
| Close | `CloseDB()` | |

```powershell
busy-bridge query --comp COMP0001 --sql "SELECT TOP 3 Code, Name FROM Master1"
# opens the company (OpenDB), runs GetRecordset, closes again
```

> ⚠️ **Never** open the same company concurrently in the BUSY GUI *and* a
> headless COM session — file-lock contention crashes BUSY (observed).

## Saving masters and vouchers through XML

XML formats come from BUSY's own export utility
(*Administration → Data Export Import (XML) → Export Data*), or from
`GetMasterXML` / `GetVchXML`.

| Function | Rel 14 signature | Change vs old docs |
|---|---|---|
| `SaveMasterFromXML` | `(p_Mastertype, p_XMLStr, p_ErrStr, p_Modify, p_MasterCode, p_Source)` | grew from 4 → 6 params; 4-arg call still accepted |
| `SaveVchFromXML` | (8 params) | grew from 5 (GST-era keys) |
| `AddMasterFromXML` / `AddVchFromXML` | add-only variants | |
| `DeleteMasterByCode` | `(p_MasterCode, p_ErrStr)` | |

- `p_Mastertype` / `p_VchType` are integer codes — see [constants.md](constants.md).
- `p_ErrStr` is ByRef: pass `{"$byref":""}` (bridge JSON) and read the
  failure reason back from `outs`.
- `p_Modify` decides modify-vs-reject for existing keys; modify-key
  semantics unchanged (`VCHNO_SERIES_DATE=0 … VCHCODE_ONLY=5`).

**With busy-bridge (JSON default):**

```powershell
$a = '[2, {"Account":{"Name":"X", ...}}, {"$byref":""}, false]'   # type, document OBJECT, err, modify
busy-bridge call --comp COMP0001 --method SaveMasterFromXML --args-b64 ([Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($a)))
```

The bridge serializes the object to BUSY's XML (a raw XML string at that
position is also accepted unchanged).

## Fetching data

| Function | Purpose | Status |
|---|---|---|
| `GetRecordset(sql)` | SQL against the open financial-year DB → DAO recordset | ✅ unchanged |
| `GetRecordsetFromCompanyDB(sql)` | SQL against the common company DB | ✅ unchanged |
| `ExecuteQuery(sql[, raiseErr[, errMsg]])` | run SQL without a resultset | ✅ unchanged |
| `ExecuteQueryInADOForSQL` / `ExecuteQueryInDB` | additional SQL paths (SQL Server mode) | present in Rel 14 |
| `GetMasterXML(code, loadPartial)` / `GetVchXML(...)` | fetch a document as XML | ✅ on COM (was web-service only in old docs) |
| `GetCompConfigXML`, `GetMastConfigXML`, `GetVchConfigXML`, `GetCurrentUserXML` | company/user config documents | new since old docs |

**JSON mode with busy-bridge returns XML-bearing results as parsed trees —
never as escaped string blobs.**

### GetRecordset semantics (observed against DEMO, issue #6)

BUSY gives **no SQL diagnostics** — you must infer the failure from the shape
of the result:

| Query | Result | Evidence |
|---|---|---|
| SQL runs, rows exist | `ok:true` + rows | `SELECT Code FROM Master1 WHERE Name='Sundry Debtors'` → `rows:[{Code:116}]` |
| SQL runs, **empty table** | `ok:true` + `rows:[]` | `SELECT TOP 1 VchCode FROM Tran1` (empty company) → `rows:[]`; `SELECT COUNT(*) FROM Tran1` → `n:0` |
| **Missing table** | `code:"no_recordset"` | `SELECT TOP 1 X FROM NoSuchTableX` → `vt=0`, no error text |
| **Missing column** | `code:"no_recordset"` — *same as missing table* | `SELECT Code FROM Tran1` (Tran1 has `VchCode`, not `Code`) → `vt=0` |

- The bridge maps `VT_EMPTY` → machine code `no_recordset` with a hint that
  the SQL could not run (unknown table/column). Missing table and missing
  column are **indistinguishable** from the COM side.
- **`LIKE` predicates silently return empty**: `Name LIKE 'Sundry%'` →
  `rows:[]` even when `Name = 'Sundry Debtors'` matches. Use `=` / `IN`, or
  fetch and filter client-side.
- `Tran1` columns: `VchCode, VchType, Date, VchNo, VchSeriesCode,
  MasterCode1/2…` (`Master1` uses `Code` — different key column).

### Voucher round-trip recipe (issue #6, live test)

`tests/live/04-voucher-roundtrip.ps1` exercises the full write path —
`SaveVchFromXML` → row in `Tran1` → `GetVchXML` (JSON tree **and** raw XML
passthrough) → `DeleteVchByCode` → gone:

- **Voucher series are type-partitioned**: a SALE save (`p_VchType=9`)
  needs a series *for type 9* — the default `09Main` series belongs to that
  type; series for other types are rejected with `Invalid voucher series`.
  `CreateVchSeries(name, type)` is the programmatic escape hatch, and the
  created master is stored **type-prefixed**: `CreateVchSeries("ZigVch9",9)`
  → `Master1` row `MasterType=21, Name='09ZigVch9'` (lookup accordingly).
- MasterTypes used by the fixtures: item group **5**, item **6**,
  voucher series **21**, account groups **1** (e.g. Sundry Debtors).
- Prerequisites (party, STPT, unit, godown/MC names) are declared at the
  top of the test — a test that encodes its own prerequisites is a fixture.

## The complete surface

The old *BUSY Functions.docx* documented a fraction of what exists. Rel 14
exposes (verified live):

- **925** registered `Busy*` COM classes
- **4,496** members across the 16 core classes — full catalog:
  [function-reference.md](function-reference.md) (generated from the type
  library; regenerate after upgrades)
- Beyond `CFixedInterface`: `CMasterServices`, `CTranServices`,
  `COtherServices` (1,214 members), report/statutory `CSR_*` classes, and
  .NET assemblies (`busyNetLib`, `BusyAutoNetLib` with GST/e-invoice helpers)
- New capability families absent from the old docs: **GST/e-invoice/e-way
  bill** (`GenerateEInvoice4Vch_V2`, `GenerateGSTR1eReturnExcel`, …),
  branch-aware balances, PDF invoice generation, and dynamic dispatch via
  `CallFunction` / `CallInternalAddOnDotNetDll`

Explore interactively:

```powershell
busy-bridge surface --member OpenDB                     # one member's signature
busy-bridge surface --prog-id Busy2L21.CTranServices    # any registered class
```

## Practical recipes

```powershell
# read config as a JSON tree (no XML handling needed)
busy-bridge call --comp COMP0001 --method GetCompConfigXML --args '[false]'

# same in XML mode: byte-identical passthrough
busy-bridge call --comp COMP0001 --method GetCompConfigXML --args '[false]' --out xml

# out-parameters (ByRef) via $byref wrapper, results in "outs"
busy-bridge call --comp COMP0001 --method SaveMasterFromXML --args-b64 <b64>
```

Full argument/JSON rules: repository [README](../README.md).
Working end-to-end scripts: [`../tests/live/`](../tests/live/).
