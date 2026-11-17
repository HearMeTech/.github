# Administrative & Maintenance Scripts

This directory contains utility scripts for managing repositories, workflows, and maintenance tasks across the **@HearMeTech** organization.

## Prerequisites

Before running any scripts in this folder, ensure you have the following installed and configured:

* **[GitHub CLI (`gh`)](https://cli.github.com/)** — installed on your machine.
* **Authentication** — you must be logged in (`gh auth login`) with an account that has **Admin/Owner** permissions for the target repository.

---

## Available Scripts

### `cleanup-workflow-runs.sh`

Deletes old GitHub Actions workflow runs from a specified repository while preserving the **5 most recent runs** by default. Includes a confirmation prompt before permanently deleting any data.

**Usage:**

1. Make sure the script is executable (only needed once):

   ```bash
   chmod +x scripts/cleanup-workflow-runs.sh
   ```

2. Run with a repository name as an argument (defaults to the `HearMeTech` organization):

   ```bash
   ./scripts/cleanup-workflow-runs.sh <repo-name>
   ```

3. Or run interactively without arguments (the script will prompt you for the repository name):

   ```bash
   ./scripts/cleanup-workflow-runs.sh
   ```

**Configuration:**
You can adjust default settings (such as `DEFAULT_ORG` or `KEEP_COUNT`) directly at the top of the `cleanup-workflow-runs.sh` file.
