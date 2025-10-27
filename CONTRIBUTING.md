# Welcome to HearMeTech!

Thank you for your interest in contributing to our mission. We are building technology to give a voice to everyone, and your help is invaluable.

These guidelines help us maintain a high standard of quality and consistency across all our projects.

## 💻 Our Workflow

To ensure stability, we protect our `main` branch. All changes must be submitted via a Pull Request (PR).

1.  **Fork** the repository (if you are an external contributor).
2.  **Create a new branch** from `main` using our naming conventions (see below).
3.  **Make your changes** and write clear commit messages (see below).
4.  **Push** your branch to GitHub.
5.  **Create a Pull Request** targeting our `main` branch.
6.  **Wait for a review** from one of our core team members.

## 🌿 Branch Naming Strategy

We use a categorized naming convention to understand the purpose of a branch at a glance.

**Format:** `type/short-description-in-kebab-case`

### Branch Types:

* **`feature/`**: For developing a new feature (e.g., `feature/add-contact-form`).
* **`fix/`** (or `bugfix/`): For fixing a bug (e.g., `fix/menu-not-opening-on-mobile`).
* **`refactor/`**: For improving code structure without changing functionality (e.g., `refactor/optimize-image-loading`).
* **`chore/`**: For routine tasks that don't affect production code (e.g., `chore/update-readme` or `chore/setup-eslint`).
* **`docs/`**: For writing or updating documentation (e.g., `docs/add-api-guide`).

## ✍️ Commit Message Guidelines (Conventional Commits)

We follow the **Conventional Commits** standard. This allows us to automate changelog generation and easily track project history.

**Format:** `<type>(<scope>): <description>`

### Commit Types (`<type>`):

* **`feat`**: A new feature for the user.
* **`fix`**: A bug fix for the user.
* **`chore`**: Changes to build process, config files, or auxiliary tools.
* **`docs`**: Documentation-only changes.
* **`style`**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc).
* **`refactor`**: A code change that neither fixes a bug nor adds a feature.
* **`test`**: Adding missing tests or correcting existing tests.

### Scope (`<scope>`):
The scope is optional and should be a noun in parentheses describing the section of the codebase (e.g., `(landing)`, `(auth)`, `(header)`).

### Description (`<description>`):
* Use the **imperative, present tense**: "add" (not "added" or "adding").
* Start with a **lowercase letter**.
* **Do not** end with a period (`.`).

### Examples:

* `feat(landing): add v1.0 structure and content`
* `fix(header): correct navigation link typo`
* `chore: update eslint configuration`
* `docs(readme): add project setup instructions`

---

Thank you for contributing to HearMeTech!
