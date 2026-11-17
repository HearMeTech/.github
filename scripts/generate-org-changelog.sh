#!/usr/bin/env bash

# ==============================================================================
# Script: generate-org-changelog.sh
# Description: Generates a consolidated Markdown report of all merged Pull Requests
#              and published releases across the organization for the last N days.
# Usage: ./generate-org-changelog.sh [days] [output_file]
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

# --- CONFIGURATION ---
DAYS="${1:-}"
OUTPUT_FILE="${2:-CHANGELOG_REPORT.md}"

check_prerequisites

if [ -z "$DAYS" ]; then
    read -rp "Enter number of days to include in the report [default: 7]: " DAYS
    DAYS="${DAYS:-7}"
fi

if ! [[ "$DAYS" =~ ^[0-9]+$ ]]; then
    echo "Error: Days must be a positive integer." >&2
    exit 1
fi

SINCE_DATE=$(date -u -d "$DAYS days ago" +"%Y-%m-%d")
TODAY=$(date -u +"%Y-%m-%d")

# Check if output file exists and ask before overwriting
if [ -f "$OUTPUT_FILE" ]; then
    echo "WARNING: File '$OUTPUT_FILE' already exists and will be overwritten."
    read -rp "Do you want to continue? [y/N]: " CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Yy]([Ee][Ss])?$ ]]; then
        echo "Operation cancelled by user."
        exit 0
    fi
fi

echo "Fetching repositories for '$DEFAULT_ORG'..."
ALL_REPOS=$(gh repo list "$DEFAULT_ORG" --limit 500 --json nameWithOwner --jq '.[].nameWithOwner')

{
    echo "# $DEFAULT_ORG Engineering Changelog"
    echo ""
    echo "**Period:** $SINCE_DATE to $TODAY (Last $DAYS days)"
    echo ""
    echo "---"
    echo ""
} > "$OUTPUT_FILE"

FOUND_ANY=0

while IFS= read -r REPO; do
    [ -z "$REPO" ] && continue
    echo "Scanning '$REPO'..."

    # Fetch merged PRs since SINCE_DATE
    MERGED_PRS=$(gh pr list --repo "$REPO" --state merged --search "merged:>=$SINCE_DATE" \
        --json number,title,author,url \
        --jq '.[] | "- PR #\(.number): [\(.title)](\(.url)) (@\(.author.login))"' 2>/dev/null || true)

    # Fetch releases published since SINCE_DATE
    RELEASES=$(gh api -X GET "/repos/$REPO/releases" \
        --jq ".[] | select(.published_at >= \"${SINCE_DATE}T00:00:00Z\") | \"- **Release \(.tag_name)**: [\(.name // .tag_name)](\(.html_url))\"" 2>/dev/null || true)

    if [ -n "$MERGED_PRS" ] || [ -n "$RELEASES" ]; then
        FOUND_ANY=1
        {
            echo "## $REPO"
            echo ""
            if [ -n "$RELEASES" ]; then
                echo "### Releases"
                echo "$RELEASES"
                echo ""
            fi
            if [ -n "$MERGED_PRS" ]; then
                echo "### Merged Pull Requests"
                echo "$MERGED_PRS"
                echo ""
            fi
        } >> "$OUTPUT_FILE"
    fi
done <<< "$ALL_REPOS"

if [ "$FOUND_ANY" -eq 0 ]; then
    echo "_No merged Pull Requests or releases found during this period._" >> "$OUTPUT_FILE"
fi

echo ""
echo "Report successfully generated: $OUTPUT_FILE"
