#!/usr/bin/env bash

# ==============================================================================
# Script: cleanup-workflow-runs.sh
# Description: Deletes old GitHub Actions workflow runs across matching
#              repositories, keeping only the most recent N runs per repo.
# Usage: ./cleanup-workflow-runs.sh [repo_or_wildcard]
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

# --- CONFIGURATION ---
KEEP_COUNT=5

check_prerequisites
resolve_repositories "${1:-}"

declare -A REPO_RUNS_TO_DELETE
TOTAL_TO_DELETE=0

echo ""
echo "Scanning workflow runs (keeping last $KEEP_COUNT per repository)..."

for REPO in "${TARGET_REPOS[@]}"; do
    ALL_RUN_IDS=$(gh api -X GET "/repos/$REPO/actions/runs" --paginate -q '.workflow_runs[].id' 2>/dev/null || true)

    if [ -z "$ALL_RUN_IDS" ]; then
        echo "  - $REPO: No workflow runs found (or inaccessible)."
        continue
    fi

    COUNT=$(echo "$ALL_RUN_IDS" | wc -l | xargs)
    if [ "$COUNT" -le "$KEEP_COUNT" ]; then
        echo "  - $REPO: $COUNT run(s) found. Nothing to delete."
        continue
    fi

    IDS_TO_DELETE=$(echo "$ALL_RUN_IDS" | tail -n +$((KEEP_COUNT + 1)))
    DEL_COUNT=$(echo "$IDS_TO_DELETE" | wc -l | xargs)

    REPO_RUNS_TO_DELETE["$REPO"]="$IDS_TO_DELETE"
    TOTAL_TO_DELETE=$((TOTAL_TO_DELETE + DEL_COUNT))
    echo "  - $REPO: $COUNT total -> $DEL_COUNT run(s) marked for deletion."
done

if [ "$TOTAL_TO_DELETE" -eq 0 ]; then
    echo ""
    echo "All matched repositories are already clean!"
    exit 0
fi

# --- WARNING & CONFIRMATION ---
echo ""
echo "======================================================================"
echo "WARNING: You are about to permanently delete $TOTAL_TO_DELETE workflow run(s)"
echo "         across ${#REPO_RUNS_TO_DELETE[@]} repository(ies)."
echo "         The $KEEP_COUNT most recent run(s) per repository will be preserved."
echo "         This action CANNOT be undone."
echo "======================================================================"
read -rp "Are you sure you want to proceed? [y/N]: " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    echo "Operation cancelled by user."
    exit 0
fi

# --- DELETION PROCESS ---
echo ""
echo "Starting cleanup..."
DELETED=0

for REPO in "${!REPO_RUNS_TO_DELETE[@]}"; do
    echo "Cleaning '$REPO'..."
    for RUN_ID in ${REPO_RUNS_TO_DELETE[$REPO]}; do
        DELETED=$((DELETED + 1))
        echo "  [$DELETED/$TOTAL_TO_DELETE] Deleting run ID $RUN_ID in $REPO..."
        gh api -X DELETE "/repos/$REPO/actions/runs/$RUN_ID" --silent
    done
done

echo ""
echo "Cleanup complete! Permanently deleted $DELETED workflow run(s)."
