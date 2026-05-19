# Claude Code Workflow System

A complete setup for building production-grade projects with Claude Code
across multiple chats — without losing context, decisions, or documentation.

***

## What's in This System

```
your-project/
├── docs/
│   ├── CLAUDE.md              ← Rules for every Claude chat (READ FIRST)
│   ├── architecture.md        ← How the system is structured
│   ├── design-decisions.md    ← Why things were chosen the way they were
│   ├── changelog.md           ← What changed and when
│   └── progress.md            ← What's done, in progress, and next
│
└── scripts/
    ├── session-start.sh       ← Run BEFORE opening a new chat
    ├── new-feature.sh         ← Run at the START of any new feature
    ├── doc-prompt.sh          ← Copy-paste prompts to use during a session
    ├── decision-update.sh     ← Run IMMEDIATELY when a decision changes
    └── context-handoff.sh     ← Run when context is ~70-80% full
```

***

## The 5-Script Workflow

### 1. `session-start.sh` — Before every new chat

```bash
./scripts/session-start.sh
```

Shows you the current project state: what's done, last session summary,
and a suggested first message to paste into Claude.
If a handoff file from last session exists, it will tell you to use that.

***

### 2. `new-feature.sh` — When starting any new feature

```bash
./scripts/new-feature.sh
```

Walks you through naming the feature, listing sub-tasks, and constraints.
Adds a checklist to `progress.md`.
Generates a ready-to-paste planning prompt for Claude that forces a
design-first conversation before any code is written.

***

### 3. `doc-prompt.sh` — During a session, when you want to document

```bash
./scripts/doc-prompt.sh
```

Prints 5 ready-to-use prompts to paste into Claude for different situations:
- After making a decision
- After implementing a slice
- When a decision needs to change
- At start of a new feature
- At end of session

Keeps your documentation reflex sharp without you having to remember the words.

***

### 4. `decision-update.sh` — When a decision changes mid-build

```bash
./scripts/decision-update.sh
```

The most important script. Run it THE MOMENT you realize a previous decision
(in design-decisions.md or architecture.md) no longer applies.

It:
- Logs the old decision and why it changed
- Appends the new decision
- Adds a note to changelog.md
- Reminds you to mark the old entry in design-decisions.md as [REVISED]

This prevents the biggest multi-chat problem: the next chat reading stale
decisions and hallucinating based on them.

***

### 5. `context-handoff.sh` — When the chat context is ~70-80% full

```bash
./scripts/context-handoff.sh
```

A full end-of-chat ritual. It walks you through:
- Checking which docs need updating
- Logging decisions, architecture changes, implementations, observations
- Updating progress.md
- Generating a `docs/next-chat-starter.md` — the first message for your next chat

***

## Daily Workflow at a Glance

```
BEFORE CHAT:
  $ ./scripts/session-start.sh
  → Read the briefing
  → Open Claude, paste the starter message

STARTING A NEW FEATURE:
  $ ./scripts/new-feature.sh
  → Paste the generated planning prompt into Claude
  → Design before code

DURING THE SESSION:
  $ ./scripts/doc-prompt.sh
  → Copy a prompt, paste into Claude, document what just happened

IF A DECISION CHANGES:
  $ ./scripts/decision-update.sh
  → Log the revision IMMEDIATELY

ENDING A SESSION:
  $ ./scripts/context-handoff.sh
  → Update all docs, generate next-chat-starter.md
  → Copy that file's content into your next chat
```

***

## The Core Documentation Principle

Documentation happens in 3 moments — not after you're done:

| When | What | Where |
|------|------|-------|
| During planning | Decision made + why | `design-decisions.md` |
| After a working slice | What was built | `changelog.md` |
| When something surprises you | Observation / learning | `changelog.md` (Observations section) |
| When structure changes | Module/layer update | `architecture.md` |
| End of session | Status update | `progress.md` |

***

## How Decisions That Change Are Handled

1. Run `decision-update.sh`
2. Manually open `design-decisions.md`, find the old entry, add: `[REVISED — DATE]`
3. The new entry below it becomes the active truth
4. `changelog.md` has a full trail of what changed and why

The next Claude chat will read all of this and know the current truth —
not the outdated first draft.

***

## How to Copy This Into a New Project

1. Copy the `docs/` folder and `scripts/` folder into your project root
2. Fill in the blanks in `docs/architecture.md` (tech stack, modules)
3. Add your spec file to the project root
4. Make scripts executable: `chmod +x scripts/*.sh`
5. Run `./scripts/session-start.sh` to start your first session

***

## First Message to Claude (Very First Chat)

```
This is a new project. I've set up a docs/ folder with CLAUDE.md,
architecture.md, design-decisions.md, changelog.md, and progress.md.

Please read docs/CLAUDE.md first — it tells you how I want to work.
Then read docs/progress.md and docs/architecture.md.

Today we want to: [FIRST TASK — e.g. "agree on the tech stack and set up the project skeleton"]

Once you've read the docs, confirm your understanding and ask me one
clarifying question before we start.
```
