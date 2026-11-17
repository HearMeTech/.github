#!/usr/bin/env bash

# ==============================================================================
# File: common.sh
# Description: Shared helper functions for HearMeTech administrative scripts.
#              Handles GitHub CLI validation and wildcard repository resolution.
# ==============================================================================

DEFAULT_ORG="HearMeTech"

check_prerequisites() {
    if ! command -v gh &> /dev/null; then
        echo "Error: GitHub CLI (gh) is not installed. Please install it first." >&2
        exit 1
    fi

    if ! gh auth status &> /dev/null; then
        echo "Error: You are not logged into GitHub CLI. Run 'gh auth login' first." >&2
        exit 1
    fi
}

# Resolves a repository name or wildcard pattern (e.g., "web", "hearme-*", "*")
# Sets the global array TARGET_REPOS with full "Owner/Repo" names.
resolve_repositories() {
    local input_pattern="${1:-}"

    if [ -z "$input_pattern" ]; then
        read -rp "Enter repository name or wildcard pattern (e.g., my-repo, hearme-*, *): " input_pattern
    fi

    # Trim whitespace
    input_pattern="$(echo "$input_pattern" | xargs)"

    if [ -z "$input_pattern" ]; then
        echo "Error: Repository name or pattern cannot be empty. Aborting." >&2
        exit 1
    fi

    local org="$DEFAULT_ORG"
    local repo_pattern="$input_pattern"

    # Extract organization if provided in "org/pattern" format
    if [[ "$input_pattern" == *"/"* ]]; then
        org="${input_pattern%%/*}"
        repo_pattern="${input_pattern#*/}"
    fi

    TARGET_REPOS=()

    # If no wildcard characters (* or ?), treat as an exact repository name
    if [[ "$repo_pattern" != *"*"* && "$repo_pattern" != *"?"* ]]; then
        TARGET_REPOS+=("$org/$repo_pattern")
        return 0
    fi

    echo "Fetching repository list from '$org' matching '$repo_pattern'..."
    local all_repos
    all_repos=$(gh repo list "$org" --limit 500 --json nameWithOwner --jq '.[].nameWithOwner')

    if [ -z "$all_repos" ]; then
        echo "Error: No repositories found in organization '$org' or access denied." >&2
        exit 1
    fi

    while IFS= read -r full_repo; do
        local repo_name="${full_repo#*/}"
        # Bash pattern matching (unquoted $repo_pattern enables wildcard expansion)
        # shellcheck disable=SC2053
        if [[ "$repo_name" == $repo_pattern ]]; then
            TARGET_REPOS+=("$full_repo")
        fi
    done <<< "$all_repos"

    if [ ${#TARGET_REPOS[@]} -eq 0 ]; then
        echo "No repositories matched pattern '$org/$repo_pattern'."
        exit 0
    fi

    echo "Matched ${#TARGET_REPOS[@]} repository(ies): ${TARGET_REPOS[*]}"
}
