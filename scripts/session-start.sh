#!/usr/bin/env bash
# =============================================================================
# session-start.sh
# Run this BEFORE opening a new Claude Code chat.
# It shows you the current state of the project so you know exactly
# what to tell Claude in your first message.
# =============================================================================

DOCS_DIR="$(cd "$(dirname "$0")/../docs" && pwd)"

BOLD="\033[1m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RESET="\033[0m"

separator() { echo -e "${CYAN}────────────────────────────────────────────────────────${RESET}"; }

clear
separator
echo -e "${BOLD}  SESSION START BRIEFING — $(date '+%Y-%m-%d %H:%M')${RESET}"
separator

# ── Check if next-chat-starter exists ────────────────────────────────────────
if [ -f "$DOCS_DIR/next-chat-starter.md" ]; then
  echo ""
  echo -e "${GREEN}✓ A handoff message from the last session exists:${RESET}"
  echo -e "  ${CYAN}docs/next-chat-starter.md${RESET}"
  echo ""
  echo -e "  ${YELLOW}Open that file and paste its contents as your first Claude message.${RESET}"
  echo ""
  separator
fi

# ── Show current progress summary ────────────────────────────────────────────
echo ""
echo -e "${BOLD}  PROGRESS SNAPSHOT${RESET}"
echo ""

if [ -f "$DOCS_DIR/progress.md" ]; then
  # Extract last few lines with context markers
  TOTAL=$(grep -c "\- \[" "$DOCS_DIR/progress.md" 2>/dev/null || echo "0")
  DONE=$(grep -c "\- \[x\]" "$DOCS_DIR/progress.md" 2>/dev/null || echo "0")
  echo -e "  Checklist items: ${GREEN}$DONE done${RESET} / $TOTAL total"
  echo ""
  echo -e "  ${BOLD}Recently Completed:${RESET}"
  grep -A5 "## Recently Completed" "$DOCS_DIR/progress.md" | tail -5 | grep "^-" | head -5 | while read -r line; do
    echo -e "  ${GREEN}✓${RESET} ${line#- }"
  done
  echo ""
  echo -e "  ${BOLD}Next Up:${RESET}"
  grep -A5 "## Currently In Progress" "$DOCS_DIR/progress.md" | tail -5 | grep "^-" | head -5 | while read -r line; do
    echo -e "  ${YELLOW}▶${RESET} ${line#- }"
  done
else
  echo -e "  ${YELLOW}progress.md not found${RESET}"
fi

# ── Show latest changelog entry ───────────────────────────────────────────────
echo ""
separator
echo -e "${BOLD}  LAST SESSION (from changelog.md)${RESET}"
echo ""

if [ -f "$DOCS_DIR/changelog.md" ]; then
  # Extract the most recent dated entry
  awk '/^## \[/{count++; if(count==1){found=1} else if(count==2){exit}} found{print}' "$DOCS_DIR/changelog.md" | head -20
else
  echo -e "  ${YELLOW}changelog.md not found${RESET}"
fi

# ── Show any open decisions ───────────────────────────────────────────────────
echo ""
separator
echo -e "${BOLD}  RECENT DECISIONS (last 5 from design-decisions.md)${RESET}"
echo ""

if [ -f "$DOCS_DIR/design-decisions.md" ]; then
  grep "^\- \[20" "$DOCS_DIR/design-decisions.md" | tail -5 | while read -r line; do
    echo -e "  ${MAGENTA}•${RESET} ${line#- }"
  done
else
  echo -e "  ${YELLOW}design-decisions.md not found${RESET}"
fi

# ── Suggested first message template ─────────────────────────────────────────
echo ""
separator
echo -e "${BOLD}  SUGGESTED OPENING MESSAGE FOR CLAUDE${RESET}"
echo ""
echo -e "  If no handoff file exists, use this template:"
echo ""
echo -e "  ${CYAN}\"We're continuing work on [project name]."
echo -e "   Please read docs/progress.md, docs/architecture.md,"
echo -e "   docs/design-decisions.md and docs/changelog.md (last 2 entries)."
echo -e "   Today we want to: [NEXT TASK]."
echo -e "   Once you've read the docs, confirm your understanding"
echo -e "   and ask me one clarifying question before we start.\"${RESET}"
echo ""
separator
