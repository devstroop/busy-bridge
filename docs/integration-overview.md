# Integration overview

> Migrated from *Integration Options in BUSY.docx*, updated against live
> BUSY Rel 14 (2026-10-08).

## Customization vs integration

BUSY distinguishes two engagement types:

- **Customization** — altering BUSY itself for one customer (done by BUSY
  Solution Partners, chargeable).
- **Integration** — connecting an *external* application to BUSY so data
  entered in one is available in the other (the subject of this doc set).

Example from the original: orders placed on a web portal are posted into
BUSY automatically, so inventory is maintained without double entry.

## The five modes — status on Rel 14

| # | Mode | Rel 14 status | Details |
|---|---|---|---|
| 1 | **Integration via BUSY DLL (COM, XML)** | ✅ Fully working, **recommended** — the `busy-bridge` core | [com-xml-interface.md](com-xml-interface.md) |
| 2 | **BUSY as Web Service (port 981)** | ⚠️ Protocol unchanged (SC 1–9) but hosted inside the GUI process; fragile — crashes under company-open contention. Prefer `busy-bridge serve` | [web-service.md](web-service.md) |
| 3 | **Internal AddOns (VB6, invoked from BUSY)** | ✅ Mechanism intact, extended: `.NET` add-ons now supported | [internal-addons.md](internal-addons.md) |
| 4 | **Custom Reports (VBScript)** | ✅ Mechanism intact (license-bound) | [custom-reports.md](custom-reports.md) |
| 5 | **Custom Validations (VBScript)** | ✅ Mechanism intact | [custom-validations.md](custom-validations.md) |

### Mode 1 — BUSY DLL (COM)

External app creates a late-bound COM object of `CFixedInterface` (no DLL
reference needed — BUSY's own installation provides the ActiveX DLL) and
exchanges data as predefined **XML documents** plus raw **SQL** over DAO
recordsets. BUSY does **not** need to be open in the UI.

```text
old docs:   CreateObject("Busy2L17.CFixedInterface")   (BUSY 2017)
Rel 14:     CreateObject("Busy2L21.CFixedInterface")   (version-suffixed!)
now:        busy-bridge (any language via JSON/XML)    (see com-xml-interface.md)
```

### Mode 2 — Web service at port 981

BUSY acts as an HTTP server on port 981; the caller passes service codes in
HTTP headers (`SC=1..9`). **Requirement carried over from the old docs and
verified:** the BUSY application must be open *and the company logged in* —
otherwise the listener stays up but every route 404s.

### Modes 3–5 — in-process extensions

AddOns (custom screens), Custom Reports (custom formats) and Custom
Validations (entry-time rules) all run **inside** BUSY via VBScript or VB6
ActiveX DLLs, registered through files in `C:\BusyWin\System` (AddOns.ini)
or the Custom Report/Scripts menus.

## Choosing a mode

```mermaid
flowchart TD
    A[Need data in/out of BUSY?] -->|from any language, headless| B[busy-bridge<br/>COM/JSON/XML]
    B --> C{UI-less server integration?}
    C -->|yes| D[busy-bridge serve<br/>Accept: application/xml|json]
    C -->|legacy client| E[port 981 SC 1..9]
    A -->|custom UI inside BUSY| F[Internal AddOn]
    A -->|custom print format| G[Custom Report .bcr]
    A -->|entry-time rule| H[Custom Validation .bcd]
```

For most modern integrations: **`busy-bridge`** — it speaks the same COM
layer as mode 1 with either pure JSON (default) or pure XML, over a CLI or
HTTP, and exposes the complete registered surface
(`busy-bridge classes` → 925 classes on Rel 14).
