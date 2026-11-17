#!/usr/bin/env bash

# ==============================================================================
# Script: audit-org-repos.sh
# Description: Performs a read-only security and health audit across matching
#              repositories (branch protection, open PRs, Dependabot alerts).
# Usage: ./audit-org-repos.sh [repo_or_wildcard]
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

check_prerequisites
resolve_repositories "${1:-}"

echo ""
printf "%-35s | %-10s | %-12s | %-8s | %-12s\n" "REPOSITORY" "VISIBILITY" "MAIN PROT." "OPEN PRs" "DEPENDABOT"
printf "%-35s-+-%-10s-+-%-12s-+-%-8s-+-%-12s\n" "-----------------------------------" "----------" "------------" "--------" "------------"

for REPO in "${TARGET_REPOS[@]}"; do
    REPO_INFO=$(gh api -X GET "/repos/$REPO" --jq '"\(.visibility)|\(.default_branch)"' 2>/dev/null || echo "unknown|main")
    VISIBILITY="${REPO_INFO%%|*}"
    DEFAULT_BRANCH="${REPO_INFO#*|}"

    # Check if default branch has protection rules (HTTP 200 = enabled, 404 = disabled)
    if gh api -X GET "/repos/$REPO/branches/$DEFAULT_BRANCH/protection" &> /dev/null; then
        PROT_STATUS="Yes"
    else
        PROT_STATUS="NO (!)"
    fi

    # Count open Pull Requests
    OPEN_PRS=$(gh api -X GET "/repos/$REPO/pulls?state=open&per_page=100" --jq 'length' 2>/dev/null || echo "?")

    # Check if Dependabot vulnerability alerts are enabled (HTTP 204 = enabled)
    if gh api -X GET "/repos/$REPO/vulnerability-alerts" &> /dev/null; then
        DEP_STATUS="Enabled"
    else
        DEP_STATUS="Disabled"
    fi

    printf "%-35s | %-10s | %-12s | %-8s | %-12s\n" "$REPO" "$VISIBILITY" "$PROT_STATUS" "$OPEN_PRS" "$DEP_STATUS"
done

echo ""
echo "Audit complete."
