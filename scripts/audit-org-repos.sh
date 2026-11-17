#!/usr/bin/env bash

# ==============================================================================
# Script: audit-org-repos.sh
# Description: Performs a read-only security and health audit across matching
#              repositories (size, last push, branch protection, branches,
#              open PRs, open issues, and Dependabot alerts).
#              Defaults to auditing ALL repositories ("*") if no arguments given.
# Usage: ./audit-org-repos.sh [repo_or_wildcard]
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

check_prerequisites

# Default to "*" (all repositories) if no arguments are provided
if [ "$#" -eq 0 ]; then
    resolve_repositories "*"
else
    resolve_repositories "$@"
fi

# Helper function to format KB into human-readable KB/MB/GB
format_size() {
    local kb="$1"
    awk -v kb="$kb" 'BEGIN {
        if (kb >= 1048576) printf "%.1f GB", kb / 1048576;
        else if (kb >= 1024) printf "%.1f MB", kb / 1024;
        else printf "%d KB", kb;
    }'
}

echo ""
printf "%-30s | %-9s | %-9s | %-10s | %-10s | %-8s | %-6s | %-6s | %-10s\n" \
    "REPOSITORY" "VISIB." "SIZE" "LAST PUSH" "MAIN PROT." "BRANCHES" "PRs" "ISSUES" "DEPENDABOT"
printf "%-30s-+-%-9s-+-%-9s-+-%-10s-+-%-10s-+-%-8s-+-%-6s-+-%-6s-+-%-10s\n" \
    "------------------------------" "---------" "---------" "----------" "----------" "--------" "------" "------" "----------"

TOTAL_KB=0

for REPO in "${TARGET_REPOS[@]}"; do
    # Fetch core repository metadata in a single API call
    PARSED=$(gh api -X GET "/repos/$REPO" \
        --jq '"\(.visibility)|\(.default_branch)|\(.size)|\(.pushed_at[0:10])|\(.open_issues_count)"' 2>/dev/null || true)

    if [ -z "$PARSED" ]; then
        printf "%-30s | %-9s | %-9s | %-10s | %-10s | %-8s | %-6s | %-6s | %-10s\n" \
            "$REPO" "error" "-" "-" "-" "-" "-" "-" "-"
        continue
    fi

    IFS='|' read -r VISIBILITY DEFAULT_BRANCH SIZE_KB LAST_PUSH RAW_OPEN_COUNT <<< "$PARSED"
    TOTAL_KB=$((TOTAL_KB + SIZE_KB))
    HUMAN_SIZE=$(format_size "$SIZE_KB")

    # 1. Check if default branch has protection rules
    if gh api -X GET "/repos/$REPO/branches/$DEFAULT_BRANCH/protection" &> /dev/null; then
        PROT_STATUS="Yes"
    else
        PROT_STATUS="NO (!)"
    fi

    # 2. Count total branches
    BRANCH_COUNT=$(gh api -X GET "/repos/$REPO/branches?per_page=100" --paginate --jq 'length' 2>/dev/null | \
        awk '{s+=$1} END {print s+0}')

    # 3. Count open Pull Requests
    OPEN_PRS=$(gh api -X GET "/repos/$REPO/pulls?state=open&per_page=100" --paginate --jq 'length' 2>/dev/null | \
        awk '{s+=$1} END {print s+0}')

    # GitHub's open_issues_count includes both Issues and PRs; subtract PRs for true issue count
    OPEN_ISSUES=$((RAW_OPEN_COUNT - OPEN_PRS))
    if [ "$OPEN_ISSUES" -lt 0 ]; then
        OPEN_ISSUES=0
    fi

    # 4. Check if Dependabot vulnerability alerts are enabled
    if gh api -X GET "/repos/$REPO/vulnerability-alerts" &> /dev/null; then
        DEP_STATUS="Enabled"
    else
        DEP_STATUS="Disabled"
    fi

    printf "%-30s | %-9s | %-9s | %-10s | %-10s | %-8s | %-6s | %-6s | %-10s\n" \
        "$REPO" "$VISIBILITY" "$HUMAN_SIZE" "$LAST_PUSH" "$PROT_STATUS" "$BRANCH_COUNT" "$OPEN_PRS" "$OPEN_ISSUES" "$DEP_STATUS"
done

TOTAL_HUMAN_SIZE=$(format_size "$TOTAL_KB")
echo ""
echo "Audit complete. Scanned ${#TARGET_REPOS[@]} repository(ies). Total combined size: $TOTAL_HUMAN_SIZE."
