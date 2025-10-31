# Welcome to HearMeTech!

Thank you for your interest in contributing to our mission. We are building technology to give a voice to everyone, and your help is invaluable.

These guidelines help us maintain a high standard of quality and consistency across all our projects.

## 1. Start With an Issue

All work on HearMeTech projects—whether it's a new feature, a bug fix, or documentation—must begin with a GitHub Issue.

1.  **Check for existing issues:** Before you start, please search the Issues list to see if an issue for your work already exists.
2.  **Create a new issue:** If one doesn't exist, please create a new one using the appropriate template (Bug Report or Feature Request).
3.  **Wait for triage:** The core team will review (triage) the issue, assign the correct labels (priority, stack), and discuss the implementation.
4.  **Start work:** Once the issue is triaged and approved, you can proceed to create a branch and start development.

## 2. 💻 Our Workflow

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

## 🚀 Our Technology & Standards

Our platform consists of several key components. Please adhere to the specific standards for the area you are contributing to:

* **Backend (Python):** * We follow the [PEP 8 Style Guide](https://peps.python.org/pep-0008/).
    * All code must be formatted using `Black` before committing.
    * We use `Firebase Admin SDK` for backend services.

* **Frontend (React/TypeScript):** * We use `ESLint` and `Prettier` for code linting and formatting.
    * We follow the [Airbnb React/JSX Style Guide](https://airbnb.io/javascript/react/) as a baseline for best practices.

* **iOS (Swift):** * We adhere to Apple's [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/).
    * We encourage a clean, protocol-oriented architecture (e.g., MVVM-C).

* **Android (Kotlin):** * We follow Google's [official Kotlin style guide](https://developer.android.com/kotlin/style-guide).
    * We adhere to [Android development best practices](https://developer.android.com/develop/quality-guidelines/core-app-quality) (e.g., MVVM, Repository pattern).
    
---

Thank you for contributing to HearMeTech!
