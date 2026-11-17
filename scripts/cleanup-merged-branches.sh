#!/usr/bin/env bash

# ==============================================================================
# Script: cleanup-merged-branches.sh
# Description: Finds and deletes remote branches that have already been merged
#              into the repository's default branch.
# Usage: ./cleanup-merged-branches.sh [repo_or_wildcard]
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

# --- CONFIGURATION ---
# Branches that will NEVER be deleted even if merged
PROTECTED_BRANCHES=("main" "master" "develop" "staging" "production")

is_protected() {
    local branch="$1"
    for protected in "${PROTECTED_BRANCHES[@]}"; do
        if [[ "$branch" == "$protected" ]]; then
            return 0
        fi
    done
    return 1
}

check_prerequisites
resolve_repositories "${1:-}"

declare -A REPO_BRANCHES_TO_DELETE
TOTAL_BRANCHES=0

echo ""
echo "Scanning for merged remote branches..."

for REPO in "${TARGET_REPOS[@]}"; do
    DEFAULT_BRANCH=$(gh api -X GET "/repos/$REPO" --jq '.default_branch' 2>/dev/null || true)

    if [ -z "$DEFAULT_BRANCH" ]; then
        echo "  - $REPO: Unable to determine default branch (or inaccessible)."
        continue
    fi

    ALL_BRANCHES=$(gh api -X GET "/repos/$REPO/branches" --paginate --jq '.[].name' 2>/dev/null || true)
    MERGED_LIST=""
    REPO_COUNT=0

    while IFS= read -r BRANCH; do
        [ -z "$BRANCH" ] && continue
        if [[ "$BRANCH" == "$DEFAULT_BRANCH" ]] || is_protected "$BRANCH"; then
            continue
        fi

        # Compare default branch with candidate branch:
        # "identical" or "behind" means all commits in BRANCH are already in DEFAULT_BRANCH
        STATUS=$(gh api -X GET "/repos/$REPO/compare/$DEFAULT_BRANCH...$BRANCH" --jq '.status' 2>/dev/null || true)

        if [[ "$STATUS" == "identical" || "$STATUS" == "behind" ]]; then
            MERGED_LIST+="$BRANCH"$'\n'
            REPO_COUNT=$((REPO_COUNT + 1))
            TOTAL_BRANCHES=$((TOTAL_BRANCHES + 1))
        fi
    done <<< "$ALL_BRANCHES"

    if [ "$REPO_COUNT" -gt 0 ]; then
        REPO_BRANCHES_TO_DELETE["$REPO"]="$MERGED_LIST"
        echo "  - $REPO (base: $DEFAULT_BRANCH): $REPO_COUNT merged branch(es) found:"
        while IFS= read -r b; do
            [ -n "$b" ] && echo "      * $b"
        done <<< "$MERGED_LIST"
    else
        echo "  - $REPO: No stale merged branches."
    fi
done

if [ "$TOTAL_BRANCHES" -eq 0 ]; then
    echo ""
    echo "No merged branches to delete!"
    exit 0
fi

# --- WARNING & CONFIRMATION ---
echo ""
echo "======================================================================"
echo "WARNING: You are about to permanently delete $TOTAL_BRANCHES remote branch(es)"
echo "         across ${#REPO_BRANCHES_TO_DELETE[@]} repository(ies)."
echo "         This action CANNOT be undone."
echo "======================================================================"
read -rp "Are you sure you want to proceed? [y/N]: " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    echo "Operation cancelled by user."
    exit 0
fi

# --- DELETION PROCESS ---
echo ""
echo "Deleting branches..."
DELETED=0

for REPO in "${!REPO_BRANCHES_TO_DELETE[@]}"; do
    while IFS= read -r BRANCH; do
        [ -z "$BRANCH" ] && continue
        DELETED=$((DELETED + 1))
        # URL-encode slashes in branch names (e.g., feature/login -> feature%2Flogin)
        ENCODED_BRANCH="${BRANCH//\//%2F}"
        echo "  [$DELETED/$TOTAL_BRANCHES] Deleting '$BRANCH' in $REPO..."
        gh api -X DELETE "/repos/$REPO/git/refs/heads/$ENCODED_BRANCH" --silent
    done <<< "${REPO_BRANCHES_TO_DELETE[$REPO]}"
done

echo ""
echo "Cleanup complete! Deleted $DELETED merged branch(es)."
