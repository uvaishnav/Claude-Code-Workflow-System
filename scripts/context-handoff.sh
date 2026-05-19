#!/usr/bin/env bash
# =============================================================================
# context-handoff.sh
# Run this when you're ~70-80% through a Claude chat context.
# It walks you through updating all docs and generates the next chat's
# first message so you can paste it and continue seamlessly.
# =============================================================================

set -e

DOCS_DIR="$(cd "$(dirname "$0")/../docs" && pwd)"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M)

BOLD="\033[1m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

separator() { echo -e "${CYAN}────────────────────────────────────────────────────────${RESET}"; }
header()    { echo -e "\n${BOLD}${CYAN}$1${RESET}\n"; }
prompt()    { echo -e "${YELLOW}▶ $1${RESET}"; }
success()   { echo -e "${GREEN}✓ $1${RESET}"; }
warn()      { echo -e "${RED}⚠ $1${RESET}"; }

clear
separator
echo -e "${BOLD}  CONTEXT HANDOFF — $DATE $TIME${RESET}"
separator
echo ""
echo "  This script will:"
echo "  1. Check which docs need updating"
echo "  2. Walk you through updating them"
echo "  3. Generate the next chat's starter message"
echo ""
separator

# ── Step 1: Check doc status ──────────────────────────────────────────────────
header "STEP 1 — Doc Freshness Check"

for doc in architecture.md design-decisions.md changelog.md progress.md; do
  if [ -f "$DOCS_DIR/$doc" ]; then
    LAST_MODIFIED=$(date -r "$DOCS_DIR/$doc" "+%Y-%m-%d %H:%M" 2>/dev/null || stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$DOCS_DIR/$doc" 2>/dev/null || echo "unknown")
    echo -e "  ${GREEN}✓${RESET} $doc  (last modified: $LAST_MODIFIED)"
  else
    warn "MISSING: $DOCS_DIR/$doc — create it before continuing"
  fi
done

echo ""

# ── Step 2: Decisions check ───────────────────────────────────────────────────
separator
header "STEP 2 — Decisions Made This Session"

prompt "List any decisions made this session that are NOT yet in design-decisions.md."
prompt "Format: [area] — chose X over Y because Z"
prompt "(Press ENTER on a blank line when done)"
echo ""

DECISIONS=()
while true; do
  read -r -p "  Decision: " line
  [[ -z "$line" ]] && break
  DECISIONS+=("$line")
done

if [ ${#DECISIONS[@]} -gt 0 ]; then
  echo "" >> "$DOCS_DIR/design-decisions.md"
  echo "## Added during handoff — $DATE" >> "$DOCS_DIR/design-decisions.md"
  for d in "${DECISIONS[@]}"; do
    echo "- [$DATE] ✅ $d" >> "$DOCS_DIR/design-decisions.md"
  done
  success "Appended ${#DECISIONS[@]} decision(s) to design-decisions.md"
else
  echo "  (no new decisions noted)"
fi

# ── Step 3: Architecture changes ─────────────────────────────────────────────
separator
header "STEP 3 — Architecture Changes"

prompt "Did any module structure, layer, or data model change vs. what's in architecture.md? (y/n)"
read -r -p "  Answer: " arch_changed

if [[ "$arch_changed" == "y" || "$arch_changed" == "Y" ]]; then
  prompt "Describe what changed (one line):"
  read -r -p "  Change: " arch_note
  echo "" >> "$DOCS_DIR/architecture.md"
  echo "<!-- [$DATE] UPDATED: $arch_note -->" >> "$DOCS_DIR/architecture.md"
  success "Note appended to architecture.md — open it and update the relevant section manually."
else
  echo "  (no architecture changes)"
fi

# ── Step 4: Changelog entry ───────────────────────────────────────────────────
separator
header "STEP 4 — Changelog Entry for This Session"

prompt "Give a short title for this session (e.g. 'Invoice numbering logic'):"
read -r -p "  Title: " session_title

prompt "What did you IMPLEMENT? (press ENTER on blank line when done)"
IMPL_ITEMS=()
while true; do
  read -r -p "  - " line
  [[ -z "$line" ]] && break
  IMPL_ITEMS+=("$line")
done

prompt "Any CHANGES to existing things? (press ENTER on blank line when done)"
CHANGE_ITEMS=()
while true; do
  read -r -p "  - " line
  [[ -z "$line" ]] && break
  CHANGE_ITEMS+=("$line")
done

prompt "Any OBSERVATIONS or surprises to remember? (press ENTER on blank line when done)"
OBS_ITEMS=()
while true; do
  read -r -p "  - " line
  [[ -z "$line" ]] && break
  OBS_ITEMS+=("$line")
done

# Build changelog entry
ENTRY="## [$DATE] — $session_title\n\n"
ENTRY+="### Implemented\n"
if [ ${#IMPL_ITEMS[@]} -gt 0 ]; then
  for i in "${IMPL_ITEMS[@]}"; do ENTRY+="- $i\n"; done
else
  ENTRY+="- (nothing implemented)\n"
fi
ENTRY+="\n### Changed\n"
if [ ${#CHANGE_ITEMS[@]} -gt 0 ]; then
  for c in "${CHANGE_ITEMS[@]}"; do ENTRY+="- $c\n"; done
else
  ENTRY+="- (no changes)\n"
fi
ENTRY+="\n### Observations / Surprises\n"
if [ ${#OBS_ITEMS[@]} -gt 0 ]; then
  for o in "${OBS_ITEMS[@]}"; do ENTRY+="- $o\n"; done
else
  ENTRY+="- (none)\n"
fi
ENTRY+="\n---\n"

# Prepend after the template block in changelog.md
TEMP_FILE=$(mktemp)
awk '/<!-- Paste new entries/{print; print ""; printf "%s", ENTRY; next} {print}' ENTRY="$ENTRY" "$DOCS_DIR/changelog.md" > "$TEMP_FILE"
# Fallback: append if awk didn't find marker
if ! grep -q "$session_title" "$TEMP_FILE" 2>/dev/null; then
  printf "\n%b" "$ENTRY" >> "$DOCS_DIR/changelog.md"
else
  mv "$TEMP_FILE" "$DOCS_DIR/changelog.md"
fi
success "Changelog updated."

# ── Step 5: Progress update ───────────────────────────────────────────────────
separator
header "STEP 5 — Progress Update"

prompt "What items did you COMPLETE this session? (for progress.md checkboxes — press ENTER when done)"
DONE_ITEMS=()
while true; do
  read -r -p "  ✓ " line
  [[ -z "$line" ]] && break
  DONE_ITEMS+=("$line")
done

prompt "What is the NEXT immediate task for the next session?"
read -r -p "  Next: " next_task

prompt "Any BLOCKERS or open questions?"
read -r -p "  Blocker: " blocker

# Update progress.md recently completed and next session goal
{
  echo ""
  echo "<!-- Progress updated: $DATE -->"
  echo "<!-- Next session goal: $next_task -->"
  if [ -n "$blocker" ]; then echo "<!-- Blocker: $blocker -->"; fi
} >> "$DOCS_DIR/progress.md"

success "Progress notes appended to progress.md — open it and update checkboxes manually."

# ── Step 6: Generate Next Chat Starter Message ────────────────────────────────
separator
header "STEP 6 — Next Chat Starter Message"

prompt "What is the project name?"
read -r -p "  Name: " project_name

prompt "Current phase? (e.g. Phase 1 — Core MVP)"
read -r -p "  Phase: " current_phase

prompt "Any critical context the next chat MUST know? (e.g. a rule, constraint, or pending decision)"
read -r -p "  Context: " critical_context

HANDOFF_FILE="$DOCS_DIR/next-chat-starter.md"

cat > "$HANDOFF_FILE" << HANDOFF
# Next Chat Starter Message
# Generated: $DATE $TIME
# Copy everything below this line and paste it as your FIRST message in the new chat.
# ─────────────────────────────────────────────────────────────────────────────

## Continuing: $project_name

**What we're building:** [one line description — edit this]
**Current phase:** $current_phase
**Date:** $DATE

---

### What we did last session ($session_title)

**Implemented:**
HANDOFF

for i in "${IMPL_ITEMS[@]}"; do echo "- $i" >> "$HANDOFF_FILE"; done
[ ${#IMPL_ITEMS[@]} -eq 0 ] && echo "- (see changelog.md)" >> "$HANDOFF_FILE"

cat >> "$HANDOFF_FILE" << HANDOFF

**Decisions made:**
HANDOFF

for d in "${DECISIONS[@]}"; do echo "- $d" >> "$HANDOFF_FILE"; done
[ ${#DECISIONS[@]} -eq 0 ] && echo "- (see design-decisions.md)" >> "$HANDOFF_FILE"

cat >> "$HANDOFF_FILE" << HANDOFF

---

### What to do next

- $next_task

HANDOFF

if [ -n "$blocker" ]; then
  cat >> "$HANDOFF_FILE" << HANDOFF

### Blocker / Open Question

- $blocker

HANDOFF
fi

if [ -n "$critical_context" ]; then
  cat >> "$HANDOFF_FILE" << HANDOFF

### Important Context

- $critical_context

HANDOFF
fi

cat >> "$HANDOFF_FILE" << HANDOFF

---

### Files to read first

Please read in this order before suggesting anything:
1. \`docs/progress.md\`
2. \`docs/architecture.md\`
3. \`docs/design-decisions.md\`
4. \`docs/changelog.md\` (last 2–3 entries)

Then confirm what you've understood and ask me one clarifying question
before we start today's task.
HANDOFF

separator
echo ""
success "Handoff complete! All docs updated."
echo ""
echo -e "  ${BOLD}Next chat starter message saved to:${RESET}"
echo -e "  ${CYAN}$HANDOFF_FILE${RESET}"
echo ""
echo -e "  Open that file, review it, and paste it as your"
echo -e "  first message in the new Claude Code chat."
echo ""
separator
