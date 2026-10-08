# Web service at port 981 (legacy reference)

> Migrated from *Integration using BUSY Web Service.docx*. Kept as a
> **legacy protocol reference** — for new integrations use
> `busy-bridge serve` (bottom of this page).

## Legacy protocol (still present in Rel 14)

BUSY acts as an HTTP server on **port 981**. Requests are plain HTTP with
the operation and payload carried in **custom headers**; the response body
carries the result with `Result` (`T`/`F`) and `Description` headers.

```http
GET http://localhost:981/ HTTP/1.1
SC: 1
Qry: SELECT * from Tran1 where VchType=9
UserName: Busy
Pwd: Busy
```

### Service codes (original table, verified against Rel 14)

| SC | Description | Parameters | Response |
|---|---|---|---|
| 1 | Get XML from Recordset — runs SQL, returns rowset XML | `Qry`, `UserName`, `Pwd` | body: rowset XML; `Result`, `Description` |
| 2 | Add Voucher from XML | `VchType`, `VchXML`, `UserName`, `Pwd` | body: voucher code; `Result`, `Description` |
| 3 | Modify Voucher from XML **by Voucher No.** | `VchType`, `VchXML`, `ModifyKey`, `UserName`, `Pwd` | `Result`, `Description` |
| 4 | Modify Voucher from XML **by Voucher Code** | `VchType`, `VchXML`, `VoucherCode`, `UserName`, `Pwd` | body: voucher code |
| 5 | Add Master from XML | `MasterType`, `MasterXML`, `UserName`, `Pwd` | body: master code |
| 6 | Modify Master from XML by Code | `MasterCode`, `MasterXML`, `UserName`, `Pwd` | body: master code |
| 7 | Modify Master from XML by Name | `MasterName`, `MasterType`, `MasterXML`, `UserName`, `Pwd` | `Result`, `Description` |
| 8 | Get Voucher XML | `VoucherCode`, `UserName`, `Pwd` | body: voucher XML |
| 9 | Get Master XML | `MasterCode`, `UserName`, `Pwd` | body: master XML |

`ModifyKey` values (unchanged): `VCHNO_ONLY=1`, `VCHNO_DATE=2`,
`VCHNO_SERIES=3`, `VCHNO_SERIES_DATE=4`, `VCHCODE_ONLY=5`.
Master/voucher type codes: [constants.md](constants.md).

**Exhaustively probed on Rel 14: codes 1–9 exist, `SC=10..40` → 404 — the
service surface did not grow.**

### Operational caveats (observed)

1. The BUSY application **must be open and the company logged in** — the
   TCP listener stays up when the company closes, but every route 404s.
2. It is hosted by the GUI process: reopening a company while another
   session holds it can **crash BUSY** (file-lock contention).
3. Auth = BUSY company users (`Busy`/`Busy` default), sent as headers.

→ Suitable for legacy callers; **not** recommended for new or long-running
integrations.

## Current interface: `busy-bridge serve`

Same information, negotiated per request, without the GUI dependency:

| Legacy | busy-bridge |
|---|---|
| `SC: 1` + `Qry` header | `POST /query {"sql":"..."}` |
| `SC: 1` response (rowset XML) | `Accept: application/xml` → **identical rowset structure** |
| `SC: 2/5` add from XML | `POST /call?method=Save*FromXML&type=N` with raw XML body (or JSON object arg) |
| `SC: 8/9` get XML | `GET /call?method=GetVchXML&args=...` → raw passthrough |
| fixed port 981, GUI-hosted | `--port 9820` default, headless, loopback by default |

```powershell
busy-bridge serve --comp COMP0001 --port 9820
# response format: Accept: application/xml | application/json
```

Routes, envelopes and error shapes: repository [README](../README.md).
The XML-mode `query` response intentionally mirrors the legacy `SC=1`
rowset (same namespaces/schema/rows), so an existing port-981 client can
migrate by changing URL + adding `Accept`.
