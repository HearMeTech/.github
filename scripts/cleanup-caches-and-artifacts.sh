#!/usr/bin/env bash

# ==============================================================================
# Script: cleanup-caches-and-artifacts.sh
# Description: Deletes GitHub Actions artifacts and caches older than N days
#              across matching repositories to free up storage quota.
# Usage: ./cleanup-caches-and-artifacts.sh [repo_or_wildcard]
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

# --- CONFIGURATION ---
RETENTION_DAYS=7

check_prerequisites
resolve_repositories "${1:-}"

CUTOFF_DATE=$(date -u -d "$RETENTION_DAYS days ago" +"%Y-%m-%dT%H:%M:%SZ")

declare -A REPO_ARTIFACTS
declare -A REPO_CACHES
TOTAL_ARTIFACTS=0
TOTAL_CACHES=0
TOTAL_BYTES=0

echo ""
echo "Scanning artifacts and caches older than $RETENTION_DAYS days (before $CUTOFF_DATE)..."

for REPO in "${TARGET_REPOS[@]}"; do
    # 1. Scan Artifacts
    ARTIFACTS_DATA=$(gh api -X GET "/repos/$REPO/actions/artifacts" --paginate \
        --jq ".artifacts[] | select(.created_at < \"$CUTOFF_DATE\") | \"\(.id):\(.size_in_bytes)\"" 2>/dev/null || true)

    ART_IDS=""
    ART_COUNT=0
    if [ -n "$ARTIFACTS_DATA" ]; then
        while IFS=: read -r id size; do
            ART_IDS+="$id "
            ART_COUNT=$((ART_COUNT + 1))
            TOTAL_BYTES=$((TOTAL_BYTES + size))
        done <<< "$ARTIFACTS_DATA"
        REPO_ARTIFACTS["$REPO"]="$ART_IDS"
        TOTAL_ARTIFACTS=$((TOTAL_ARTIFACTS + ART_COUNT))
    fi

    # 2. Scan Caches (based on last_accessed_at)
    CACHES_DATA=$(gh api -X GET "/repos/$REPO/actions/caches" --paginate \
        --jq ".actions_caches[] | select(.last_accessed_at < \"$CUTOFF_DATE\") | \"\(.id):\(.size_in_bytes)\"" 2>/dev/null || true)

    CACHE_IDS=""
    CACHE_COUNT=0
    if [ -n "$CACHES_DATA" ]; then
        while IFS=: read -r id size; do
            CACHE_IDS+="$id "
            CACHE_COUNT=$((CACHE_COUNT + 1))
            TOTAL_BYTES=$((TOTAL_BYTES + size))
        done <<< "$CACHES_DATA"
        REPO_CACHES["$REPO"]="$CACHE_IDS"
        TOTAL_CACHES=$((TOTAL_CACHES + CACHE_COUNT))
    fi

    if [ "$ART_COUNT" -gt 0 ] || [ "$CACHE_COUNT" -gt 0 ]; then
        echo "  - $REPO: $ART_COUNT old artifact(s), $CACHE_COUNT old cache(s)."
    else
        echo "  - $REPO: Clean."
    fi
done

if [ "$TOTAL_ARTIFACTS" -eq 0 ] && [ "$TOTAL_CACHES" -eq 0 ]; then
    echo ""
    echo "No artifacts or caches older than $RETENTION_DAYS days found!"
    exit 0
fi

TOTAL_MB=$(awk "BEGIN {printf \"%.2f\", $TOTAL_BYTES / 1048576}")

# --- WARNING & CONFIRMATION ---
echo ""
echo "======================================================================"
echo "WARNING: You are about to permanently delete:"
echo "         - $TOTAL_ARTIFACTS artifact(s)"
echo "         - $TOTAL_CACHES cache(s)"
echo "         Estimated storage to be freed: ${TOTAL_MB} MB"
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

for REPO in "${!REPO_ARTIFACTS[@]}"; do
    for ART_ID in ${REPO_ARTIFACTS[$REPO]}; do
        echo "  Deleting artifact ID $ART_ID in $REPO..."
        gh api -X DELETE "/repos/$REPO/actions/artifacts/$ART_ID" --silent
    done
done

for REPO in "${!REPO_CACHES[@]}"; do
    for CACHE_ID in ${REPO_CACHES[$REPO]}; do
        echo "  Deleting cache ID $CACHE_ID in $REPO..."
        gh api -X DELETE "/repos/$REPO/actions/caches/$CACHE_ID" --silent
    done
done

echo ""
echo "Cleanup complete! Freed approximately ${TOTAL_MB} MB across matched repositories."
