# BUSY integration documentation

Documentation for integrating external software with **BUSY Accounting
Software**, migrated from the original 2017-era Word documents and **updated
for BUSY Rel 14 and the `busy-bridge` interface**. Everything here was
verified against a live installation (company DEMO) during the migration.

## Guides

| Page | Migrated from | Status |
|---|---|---|
| [Integration overview](integration-overview.md) | *Integration Options in BUSY.docx* | Updated: 5 modes re-evaluated against Rel 14 |
| [COM / XML interface](com-xml-interface.md) | *Integration using BUSY DLL.doc*, *BUSY Functions.docx* | Rewritten around `busy-bridge`; signatures corrected |
| [Web service (legacy)](web-service.md) | *Integration using BUSY Web Service.docx* | Kept as legacy reference; superseded by `busy-bridge serve` |
| [Constants](constants.md) | *BUSY Constants.doc* | Preserved; verified against live data |
| [Custom reports](custom-reports.md) | *Designing Custom Report.doc* | Preserved workflow; scripts in [`../examples/vbscript/`](../examples/vbscript/) |
| [Custom validations](custom-validations.md) | *Custom Validation.docx* | Preserved workflow; scripts in [`../examples/vbscript/`](../examples/vbscript/) |
| [Internal AddOns](internal-addons.md) | *Custom Data Entry Screen (using Internal AddOn).docx* | Preserved; sample in [`../examples/vb6-addon/`](../examples/vb6-addon/) |
| [Database structure](database-structure.md) | *Database Structure of BUSY.doc* + 3 `.xls` | Updated: `.bds` storage model; full tables in archive |
| [**Function reference**](function-reference.md) | *(replaces BUSY Functions.docx)* | **Generated from the live type library** — 4,496 members, 16 core classes |

The wire contract (JSON/XML negotiation, envelopes, mapping rules) is
specified in the repository [README](../README.md).

## Complete archive

`archive/` holds **faithful full-text conversions** of every original
document (Word → Markdown via pandoc, Excel → Markdown via pandas), with
provenance in [`archive/MANIFEST.md`](archive/MANIFEST.md). Nothing was
summarized away — if a detail is missing from a guide above, it is in the
archive.

## Regenerating

```powershell
# re-extract the original documents (needs LibreOffice + pandoc + Python)
powershell -File scripts/docs/extract.ps1

# refresh the function reference after a BUSY upgrade (needs zig build)
powershell -File scripts/docs/generate-function-reference.ps1
```

Both scripts write deterministic, committed output — CI-friendly, reviewable
diffs show exactly what a BUSY upgrade changed.
