# Administrative & Maintenance Scripts

This directory contains utility scripts for managing repositories, workflows, and maintenance tasks across the **@HearMeTech** organization.

## Prerequisites

Before running any scripts in this folder, ensure you have the following installed and configured:

* **[GitHub CLI (`gh`)](https://cli.github.com/)** — installed on your machine.
* **Authentication** — you must be logged in (`gh auth login`) with an account that has **Admin/Owner** permissions for the target repositories.

---

## Wildcard Support

All repository-targeted scripts support exact names as well as wildcard patterns (`*`, `?`). If run without arguments, the script will prompt you interactively:

* `my-repo` — targets `HearMeTech/my-repo`
* `hearme-*` — targets all repositories in `HearMeTech` starting with `hearme-`
* `*` — targets **all** repositories in `HearMeTech`

> **Safety Note:** All destructive scripts perform a dry scan first, display the exact items scheduled for deletion, and require an explicit `[y/N]` confirmation before making any changes.

---

## Available Scripts

### 1. `cleanup-workflow-runs.sh`

Deletes old GitHub Actions workflow runs across matching repositories while preserving the **5 most recent runs** per repository.

```bash
./scripts/cleanup-workflow-runs.sh              # Interactive prompt
./scripts/cleanup-workflow-runs.sh hearme-*     # Wildcard pattern
```

### 2. `cleanup-caches-and-artifacts.sh`

Deletes GitHub Actions build artifacts and dependency caches older than **7 days** (configurable via `RETENTION_DAYS`) and reports the total storage freed.

```bash
./scripts/cleanup-caches-and-artifacts.sh       # Interactive prompt
./scripts/cleanup-caches-and-artifacts.sh *     # Scan all org repositories
```

### 3. `cleanup-merged-branches.sh`

Finds and deletes remote branches that have already been merged into the repository's default branch. Protected branches (`main`, `master`, `develop`, `staging`, `production`) are automatically skipped.

```bash
./scripts/cleanup-merged-branches.sh            # Interactive prompt
./scripts/cleanup-merged-branches.sh my-repo    # Specific repository
```

### 4. `audit-org-repos.sh`

Performs a safe, read-only security and configuration audit across matching repositories, outputting a summary table of visibility, default branch protection, open PR count, and Dependabot alert status.

```bash
./scripts/audit-org-repos.sh *                  # Audit all org repositories
```

### 5. `generate-org-changelog.sh`

Generates a consolidated Markdown changelog (`CHANGELOG_REPORT.md`) of all merged Pull Requests and published releases across the organization over the last N days (defaults to 7 days).

```bash
./scripts/generate-org-changelog.sh             # Interactive prompt (defaults to 7 days)
./scripts/generate-org-changelog.sh 14          # Report for the last 14 days
```

### `common.sh`

Internal shared library sourced by the scripts above for authentication checks and wildcard repository resolution. Not meant to be executed directly.
