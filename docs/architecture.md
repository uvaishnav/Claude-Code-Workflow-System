# Architecture

> Updated as the project evolves. If something here contradicts the code, the code wins — update this file.

***

## Project Overview

- **Project name:**
- **What it does (one sentence):**
- **App type:** (Desktop / Web / Mobile)
- **Primary user:**

***

## Tech Stack

| Layer | Choice | Why |
|---|---|---|
| UI Framework | | |
| Language | | |
| Desktop Shell | | |
| Database | | |
| PDF Generation | | |
| AI Integration | | |
| Testing | | |

***

## Module Map

```
project-root/
├── src/
│   ├── core/          # Domain logic — GST rules, invoice numbering, validations
│   ├── db/            # Database schema, migrations, queries
│   ├── ui/            # Screens and components
│   ├── pdf/           # PDF template and generation
│   └── integrations/  # AI service, OCR, external APIs
├── docs/              # This folder
└── scripts/           # Workflow helper scripts
```

***

## Module Responsibilities

### `core/`
- What lives here:
- What it must NOT do:
- Key concepts (entities, services):

### `db/`
- What lives here:
- Main tables / schemas:
- Migration strategy:

### `ui/`
- What lives here:
- Screens list:
- Component naming convention:

### `pdf/`
- What lives here:
- Template approach:
- How generation is triggered:

### `integrations/`
- What lives here:
- Each integration and its wrapper:

***

## Data Flow

> How data moves from user action → processing → storage → display.

```
[User Action]
  → [UI Component]
  → [Core / Domain function]
  → [DB / Storage]
  → [UI update]
```

***

## Key Constraints and Rules

- (e.g.) Invoice numbers must be unique within a financial year
- (e.g.) GST tax mode is auto-detected but user-overridable with logging
- (e.g.) PDF is the only output format — no Excel
- Add more here as they are discovered

***

## Cross-Cutting Concerns

- **Error handling:** 
- **Logging:**
- **Testing approach:**
- **Configuration (where settings live):**

***

## Diagrams

> Add diagrams here as needed (ASCII, Mermaid, or linked image).
