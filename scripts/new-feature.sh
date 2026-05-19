#!/usr/bin/env bash
# =============================================================================
# new-feature.sh
# Run this at the START of working on any new feature or significant task.
# It creates a planning checklist entry in progress.md and gives you a
# structured prompt to paste into Claude to begin the feature properly.
# =============================================================================

DOCS_DIR="$(cd "$(dirname "$0")/../docs" && pwd)"
DATE=$(date +%Y-%m-%d)

BOLD="\033[1m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

separator() { echo -e "${CYAN}────────────────────────────────────────────────────────${RESET}"; }
header()    { echo -e "\n${BOLD}${CYAN}$1${RESET}\n"; }
prompt()    { echo -e "${YELLOW}▶ $1${RESET}"; }
success()   { echo -e "${GREEN}✓ $1${RESET}"; }

clear
separator
echo -e "${BOLD}  NEW FEATURE SETUP — $DATE${RESET}"
separator

header "Feature Details"

prompt "Feature name (short, e.g. 'Invoice PDF generation'):"
read -r -p "  Name: " feature_name

prompt "What should the user be able to DO after this feature? (one sentence)"
read -r -p "  Goal: " user_goal

prompt "Which phase does this belong to? (e.g. Phase 1)"
read -r -p "  Phase: " phase

prompt "List the sub-tasks for this feature (press ENTER on blank line when done):"
SUBTASKS=()
while true; do
  read -r -p "  - " line
  [[ -z "$line" ]] && break
  SUBTASKS+=("$line")
done

prompt "Any known constraints or rules that apply? (press ENTER on blank line when done)"
CONSTRAINTS=()
while true; do
  read -r -p "  - " line
  [[ -z "$line" ]] && break
  CONSTRAINTS+=("$line")
done

# Add to progress.md
{
  echo ""
  echo "### $phase — $feature_name [$DATE]"
  echo "**User goal:** $user_goal"
  for t in "${SUBTASKS[@]}"; do
    echo "- [ ] $t"
  done
} >> "$DOCS_DIR/progress.md"

success "Feature checklist added to progress.md"

# Generate the Claude planning prompt
PROMPT_FILE="$DOCS_DIR/feature-start-prompt.md"
cat > "$PROMPT_FILE" << PROMPT
# Feature Start Prompt — $feature_name
# Generated: $DATE
# Paste this into Claude to begin planning the feature.
# ─────────────────────────────────────────────────────────

We're about to plan and build: **$feature_name**

**User goal:** $user_goal

**Sub-tasks I've identified:**
PROMPT

for t in "${SUBTASKS[@]}"; do
  echo "- $t" >> "$PROMPT_FILE"
done

if [ ${#CONSTRAINTS[@]} -gt 0 ]; then
  echo "" >> "$PROMPT_FILE"
  echo "**Known constraints / rules:**" >> "$PROMPT_FILE"
  for c in "${CONSTRAINTS[@]}"; do
    echo "- $c" >> "$PROMPT_FILE"
  done
fi

cat >> "$PROMPT_FILE" << PROMPT

Before we write any code, please:

1. Review the sub-tasks — am I missing anything? Are any of these two steps combined when they should be separate?
2. Propose the data model / architecture for this feature.
3. Tell me what decisions we need to make before coding (format each as "Option A vs Option B — tradeoff").
4. Tell me what to pre-document in architecture.md and design-decisions.md.

Do NOT write code yet. Let's design and discuss first.
PROMPT

separator
echo ""
success "Feature setup complete!"
echo ""
echo -e "  ${BOLD}Checklist added to:${RESET} ${CYAN}docs/progress.md${RESET}"
echo -e "  ${BOLD}Planning prompt at:${RESET} ${CYAN}docs/feature-start-prompt.md${RESET}"
echo ""
echo -e "  Open ${CYAN}docs/feature-start-prompt.md${RESET} and paste it into Claude."
separator
