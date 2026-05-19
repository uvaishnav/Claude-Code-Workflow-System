# Design Decisions

> Short, dated entries. Format: `[DATE] Area — Chose X over Y because Z.`
> When a decision changes: EDIT the old line, mark it [REVISED], and add a new one.

***

## How to Read This File

- ✅ Active decision — currently in use
- 🔄 Revised — changed during development (see note)
- ❌ Rejected — option we considered but ruled out

***

## Tech Stack Decisions

<!-- Example:
[2026-05-19] ✅ Database — Chose SQLite over PostgreSQL because the app is single-user, desktop-only, and needs zero server setup. Simplicity > scalability at this stage.
-->

***

## Architecture Decisions

<!-- Example:
[2026-05-19] ✅ Module structure — Separated core/ (domain logic) from ui/ because domain logic must be testable without rendering any UI. This follows the Ports and Adapters pattern loosely.
-->

***

## Feature / Logic Decisions

<!-- Example:
[2026-05-19] ✅ Invoice numbering — Reset sequence to 001 on April 1 each year (Indian FY). Prefix is configurable in settings. Format: PREFIX/FY/SEQ.
-->

***

## UI / UX Decisions

<!-- Example:
[2026-05-19] ✅ Color scheme — Blue-accent for intrastate invoices, green-accent for interstate. Based on spec requirement. Base is a neutral professional tone for print readability.
-->

***

## Rejected Options Log

> Things we explicitly decided NOT to do and why.

<!-- Example:
[2026-05-19] ❌ Excel output — Rejected. GST law requires correct invoice contents, not a specific format. PDF is more reliable for print/share and eliminates Excel formatting bugs.
-->
