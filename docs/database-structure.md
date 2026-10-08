# Database structure

> Migrated from *Database Structure of BUSY.doc* + the three `.xls` design
> workbooks; **updated for Rel 14's storage model**. Full table dumps:
> [archive/DBDesign.md](archive/DBDesign.md),
> [archive/BusyDatabaseDesign_DB.md](archive/BusyDatabaseDesign_DB.md),
> [archive/BusyDatabaseDesign_DB1XXXX.md](archive/BusyDatabaseDesign_DB1XXXX.md).

## Conceptual model (unchanged)

BUSY's data is two entities:

- **Master entities** — created once, mostly static (Account, Item, Cost
  Centre…).
- **Transaction entities** — day-to-day vouchers (Sales, Receipt…) that
  post into masters.

## Storage: then vs now

| | Old docs (2017) | Rel 14 (observed) |
|---|---|---|
| Engines | MS Access **or** MS SQL Server | same two (file mode + `OpenCSDB` SQL mode) |
| File mode layout | two databases per company: **year-specific** (`db` + FY, recreated per financial year) and **common** | proprietary **`.bds` files** under `C:\BusyWin\DATA\<COMPCODE>\` — direct file/MDB access is gone |
| Programmatic access | DAO recordsets over the MDB | ✅ **unchanged interface**: `GetRecordset` / `GetRecordsetFromSQL` still return DAO recordsets; raw SQL via `busy-bridge query` |
| SQL Server mode | `OpenCSDB(busyPath, server, user, pwd, comp)` | unchanged |

> Consequence: you can no longer open BUSY's data files directly with an
> Access/ODBC tool in file mode — go through **COM / busy-bridge** (or SQL
> Server mode).

## Key tables (from the original document)

**Master entity tables** (year-specific in the old model): `Master1`
(one row per master: `Code`, `MasterType`, `Name`, …), `MasterSupport`,
`MasterAddressInfo`, `Help1`, `Folio1`.

**Transaction entity tables**: `Tran1` … `Tran11` (voucher headers/lines),
plus bill/stock/GST satellites (`VchGSTSumItemWise`, `VchVATSum`,
`ItemDesc`, `PackingDetails`, …).

**Common tables**: company/config (`Company`, `FormDetails`, `Config`,
`CustomScript`, `SQLQuery`, `UserControl`, …).

### Live verification (Rel 14, DEMO)

```powershell
busy-bridge query --comp COMP0001 --sql "SELECT TOP 3 Code, MasterType, Name FROM Master1"
# -> {"rows":[{"Code":1,"MasterType":2,"Name":"Cash"}, ...]}
```

`Master1` is the universal master registry — `MasterType` holds the codes
from [constants.md](constants.md). The archive workbooks list every table
and column as of the 2017 design; treat them as a **map, not a contract** —
confirm anything critical with a live `busy-bridge query`.

## Full original document

Narrative with per-table field explanations:
[archive/Database Structure of BUSY.md](<archive/Database Structure of BUSY.md>)
