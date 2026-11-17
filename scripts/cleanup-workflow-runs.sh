#!/usr/bin/env bash

# ==============================================================================
# Script: cleanup-workflow-runs.sh
# Description: Deletes old GitHub Actions workflow runs in a repository,
#              keeping only the most recent N runs.
# Usage: ./cleanup-workflow-runs.sh [repository_name]
# ==============================================================================

set -euo pipefail

# --- CONFIGURATION (You can adjust these defaults) ---
DEFAULT_ORG="HearMeTech"
KEEP_COUNT=5

# --- PREREQUISITES CHECK ---
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed. Please install it first." >&2
    exit 1
fi

# Check if the user is authenticated with GitHub CLI
if ! gh auth status &> /dev/null; then
    echo "Error: You are not logged into GitHub CLI. Run 'gh auth login' first." >&2
    exit 1
fi

# --- DETERMINE TARGET REPOSITORY ---
INPUT_REPO="${1:-}"

if [ -z "$INPUT_REPO" ]; then
    read -rp "Enter repository name (e.g., my-repo or $DEFAULT_ORG/my-repo): " INPUT_REPO
fi

# Trim leading/trailing whitespace
INPUT_REPO="$(echo "$INPUT_REPO" | xargs)"

if [ -z "$INPUT_REPO" ]; then
    echo "Error: Repository name cannot be empty. Aborting." >&2
    exit 1
fi

# Prepend DEFAULT_ORG if the user didn't specify an organization/owner
if [[ "$INPUT_REPO" == *"/"* ]]; then
    TARGET_REPO="$INPUT_REPO"
else
    TARGET_REPO="$DEFAULT_ORG/$INPUT_REPO"
fi

echo "Fetching workflow runs for '$TARGET_REPO'..."

# --- FETCH WORKFLOW RUNS ---
# GitHub API returns runs sorted from newest to oldest by default.
# --paginate ensures we fetch all runs, not just the first page (30 items).
ALL_RUN_IDS=$(gh api -X GET "/repos/$TARGET_REPO/actions/runs" --paginate -q '.workflow_runs[].id')

if [ -z "$ALL_RUN_IDS" ]; then
    echo "No workflow runs found in '$TARGET_REPO' (or repository does not exist)."
    exit 0
fi

TOTAL_COUNT=$(echo "$ALL_RUN_IDS" | wc -l | xargs)
echo "Total workflow runs found: $TOTAL_COUNT"

if [ "$TOTAL_COUNT" -le "$KEEP_COUNT" ]; then
    echo "Nothing to delete. Total runs ($TOTAL_COUNT) do not exceed the keep limit ($KEEP_COUNT)."
    exit 0
fi

# Skip the newest KEEP_COUNT runs and collect the rest for deletion
IDS_TO_DELETE=$(echo "$ALL_RUN_IDS" | tail -n +$((KEEP_COUNT + 1)))
DELETE_COUNT=$(echo "$IDS_TO_DELETE" | wc -l | xargs)

# --- WARNING & CONFIRMATION ---
echo ""
echo "======================================================================"
echo "WARNING: You are about to permanently delete $DELETE_COUNT workflow run(s)"
echo "         from repository: $TARGET_REPO"
echo "         The $KEEP_COUNT most recent run(s) will be preserved."
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

for RUN_ID in $IDS_TO_DELETE; do
    DELETED=$((DELETED + 1))
    echo "[$DELETED/$DELETE_COUNT] Deleting workflow run ID: $RUN_ID..."
    gh api -X DELETE "/repos/$TARGET_REPO/actions/runs/$RUN_ID" --silent
done

echo ""
echo "Cleanup complete! Deleted $DELETED old run(s). $KEEP_COUNT most recent run(s) remain in '$TARGET_REPO'."
