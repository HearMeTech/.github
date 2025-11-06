# Developer Onboarding at HearMeTech

Welcome to the team! We are thrilled to have you on board. Our mission is to build technology that gives everyone the power to be heard, and your work will directly impact that mission.

This document is your guide to getting set up and ready to contribute. Please follow these steps in order.

---

## Phase 1: Understand Our Culture (Your First Hour)

Before you write any code, please familiarize yourself with our values and processes. These documents define how we work together.

* **[ ] Read our Mission:** Understand *why* we're here.
    * ➡️ **Link:** [**Our Organization Profile (`profile/README.md`)**](./profile/README.md)
* **[ ] Read our Code of Conduct:** Our pledge to maintain a respectful and inclusive community.
    * ➡️ **Link:** [**Code of Conduct (`CODE_OF_CONDUCT.md`)**](./CODE_OF_CONDUCT.md)
* **[ ] Read our Communication Policy:** How we communicate effectively.
    * ➡️ **Link:** [**Communication Policy (`COMMUNICATION_POLICY.md`)**](./COMMUNICATION_POLICY.md)
* **[ ] Read our Contribution Guidelines:** Understand our workflow (branches, commits, PRs).
    * ➡️ **Link:** [**Contribution Guidelines (`CONTRIBUTING.md`)**](./CONTRIBUTING.md)
* **[ ] Read our Security Policy:** How to responsibly report vulnerabilities.
    * ➡️ **Link:** [**Security Policy (`SECURITY.md`)**](./SECURITY.md)

---

## Phase 2: Account & Git Setup (Action Required)

This is our official **GitHub Access Policy**. We use GitHub as our central hub for code and collaboration. Follow these steps precisely to gain access to our repositories.

### 1. We Use Your Personal GitHub Account

At HearMeTech, we respect your professional identity. You will use your **personal GitHub account** to contribute. This allows you to build your personal contribution graph and avoids the hassle of managing multiple accounts.

You will soon receive an invitation to join the `@HearMeTech` organization. Please accept it.

### 2. Enable Two-Factor Authentication (2FA)

**This is a non-negotiable security requirement.**

To protect our code and our users' data, our organization **requires** all members to have 2FA enabled on their GitHub accounts. You will not be able to join or access our private repositories until you do.

* **Action:** [**Enable 2FA on your GitHub account**](https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/configuring-two-factor-authentication).

### 3. Add Your Corporate Email to GitHub

You must add your HearMeTech email address (`your.name@hearme.tech`) to your GitHub account's email settings.

* **Action:** [**Add `your.name@hearme.tech` to your account's email settings**](https://github.com/settings/emails) and verify it. You do not need to make it your primary email, but it *must* be on this list and verified.

### 4. Configure Your Local Git Commits

This is the most critical step for IP (Intellectual Property) tracking and professionalism. All code you write for HearMeTech **must** be committed using your corporate email address.

**Action:** Open your terminal and run the following command in **every HearMeTech repository** you clone:

```bash
# Set your name (if not already set correctly)
git config user.name "Your Name"

# Set your HearMeTech email FOR THIS REPOSITORY
git config user.email "your.name@hearme.tech"
```

**Why?** This ensures that every commit in our `git log` is properly attributed to your work as a HearMeTech employee. This is vital for code audits and legal IP attribution.

### 5. Offboarding

When your employment with HearMeTech ends, your personal account will be removed from our GitHub organization. This will instantly revoke your access to all private company repositories. Your public contributions (commits) will remain attributed to your account, but your access will be removed.

## Phase 3: You're All Set!

Once you have completed Phase 1 and 2, you are ready to start.

1. **Connect** with your team lead to get your first assignment.
2. **Find** an issue in the relevant repository.
3. **Follow** the workflow in [`CONTRIBUTING.md`](./CONTRIBUTING.md) to create your first branch and Pull Request.

Welcome aboard!
