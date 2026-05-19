#!/usr/bin/env bash
# =============================================================================
# decision-update.sh
# Run this IMMEDIATELY when you realize a previous decision has changed.
# This is the most important script — it prevents the #1 problem in multi-chat
# development: old decisions lying around and confusing the next chat.
# =============================================================================

DOCS_DIR="$(cd "$(dirname "$0")/../docs" && pwd)"
DATE=$(date +%Y-%m-%d)

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

clear
separator
echo -e "${BOLD}  DECISION CHANGED — $DATE${RESET}"
separator
echo ""
echo "  Use this when a previous decision was revised during development."
echo "  It will: mark the old decision as revised + log the new one + update changelog."
echo ""
separator

header "STEP 1 — The Old Decision"

prompt "What area/topic was the original decision about? (e.g. 'Database', 'Invoice numbering format')"
read -r -p "  Area: " area

prompt "Briefly: what was the original decision? (the X in 'chose X over Y')"
read -r -p "  Was: " old_decision

header "STEP 2 — The New Decision"

prompt "What are you changing it to?"
read -r -p "  Now: " new_decision

prompt "Why did this change? What did you learn or discover?"
read -r -p "  Because: " reason

prompt "Does this affect architecture.md? (y/n)"
read -r -p "  Answer: " affects_arch

header "STEP 3 — Writing the Update"

# Append the revision to design-decisions.md
cat >> "$DOCS_DIR/design-decisions.md" << ENTRY

---
## Decision Revised — $DATE

**Area:** $area
**Was:** ✅ $old_decision
**Now:** 🔄 Changed to: $new_decision
**Why:** $reason

> Note: Search for the original entry above and mark it [REVISED — see $DATE entry].
ENTRY

success "Revision appended to design-decisions.md"

# Add to changelog
cat >> "$DOCS_DIR/changelog.md" << ENTRY

## [$DATE] — Decision Revised: $area

### Changed
- **$area**: Was "$old_decision" → Now "$new_decision"
- **Reason:** $reason

### Action Required
- [ ] Find old entry in design-decisions.md and mark it 🔄 [REVISED]
ENTRY

success "Changelog updated with revision note"

if [[ "$affects_arch" == "y" || "$affects_arch" == "Y" ]]; then
  cat >> "$DOCS_DIR/architecture.md" << ENTRY

<!-- [$DATE] DECISION CHANGED: $area — was "$old_decision", now "$new_decision". Update relevant section. -->
ENTRY
  success "Note added to architecture.md — open it and update the relevant section."
fi

separator
echo ""
echo -e "${BOLD}Done. Important manual step:${RESET}"
echo ""
echo -e "  Open ${CYAN}docs/design-decisions.md${RESET}"
echo -e "  Find the original entry for: ${YELLOW}$area${RESET}"
echo -e "  Add the text ${RED}[REVISED — $DATE]${RESET} to that line"
echo ""
echo -e "  This way the file has the full history AND the current truth."
separator
