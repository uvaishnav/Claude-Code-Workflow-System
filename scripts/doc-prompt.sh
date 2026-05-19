#!/usr/bin/env bash
# =============================================================================
# doc-prompt.sh
# A quick helper to remind you what to document RIGHT NOW during a session.
# Run it whenever you finish a slice of work and want to document before
# you forget. It prints ready-made prompts to paste into Claude.
# =============================================================================

BOLD="\033[1m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
RESET="\033[0m"

separator() { echo -e "${CYAN}────────────────────────────────────────────────────────${RESET}"; }

clear
separator
echo -e "${BOLD}  DOCUMENTATION PROMPTS — paste these into Claude${RESET}"
separator

echo ""
echo -e "${BOLD}${GREEN}── After making a design decision: ──────────────────────${RESET}"
echo ""
echo -e "${CYAN}\"We just decided [X]. For documentation:"
echo -e " 1. What exact line should I add to design-decisions.md?"
echo -e " 2. Does this change anything in architecture.md? If yes, what?"
echo -e " 3. Should this go in changelog.md under 'Decisions Made'?\"${RESET}"

echo ""
separator
echo ""
echo -e "${BOLD}${GREEN}── After implementing a feature slice: ──────────────────${RESET}"
echo ""
echo -e "${CYAN}\"We just finished [feature/slice]. Help me document this:"
echo -e " 1. What 2-3 bullet points should go in changelog.md under Implemented?"
echo -e " 2. Did this change any module responsibility in architecture.md?"
echo -e " 3. Any observations or surprises worth noting?\"${RESET}"

echo ""
separator
echo ""
echo -e "${BOLD}${GREEN}── When you discover a decision needs to change: ────────${RESET}"
echo ""
echo -e "${CYAN}\"I realize [OLD DECISION] doesn't work because [REASON]."
echo -e " I want to switch to [NEW APPROACH]. Before we change the code:"
echo -e " 1. Which files and lines need to be updated in docs/?"
echo -e " 2. Write me the exact text to replace the old decision in design-decisions.md."
echo -e " 3. What do we add to changelog.md for this revision?\"${RESET}"

echo ""
separator
echo ""
echo -e "${BOLD}${GREEN}── When starting a new feature (planning stage): ────────${RESET}"
echo ""
echo -e "${CYAN}\"We're about to build [FEATURE]. Before writing any code:"
echo -e " 1. What should we document in architecture.md about how this fits in?"
echo -e " 2. Are there any decisions to pre-document in design-decisions.md?"
echo -e " 3. What checkboxes should we add to progress.md for this feature?\"${RESET}"

echo ""
separator
echo ""
echo -e "${BOLD}${GREEN}── End of session (quick doc check): ────────────────────${RESET}"
echo ""
echo -e "${CYAN}\"Before we close this chat, let's check documentation:"
echo -e " 1. What did we build today that's not yet in changelog.md?"
echo -e " 2. Are all today's decisions in design-decisions.md?"
echo -e " 3. Is progress.md up to date with what we completed?"
echo -e " 4. Draft the next chat starter message for me.\"${RESET}"

echo ""
separator
