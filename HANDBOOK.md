# The HearMeTech Handbook

Welcome to HearMeTech. This handbook is the single source of truth (SSoT) for how we work.

It is a living document, intended to be read by all team members and to grow as our company does. It outlines our mission, our culture, and the core processes we use to build products and work together effectively.

---

## 1. 🧭 Our North Star: Culture & Mission

This section defines *why* we exist and the principles that guide our decisions.

### Our Mission
Our mission is **to give everyone the power to be heard**. We build deeply personalized assistive AI that bridges the gap between our users' unique voices and the digital world.

### Our Values

* **1. Empathy-Driven Innovation:** Our work starts and ends with the user. We build *with* our community, not just *for* them, to solve real-world challenges.
* **2. Build for Reliability:** Our technology must work flawlessly in the real world. We prioritize on-device performance, speed, and offline access because our users' ability to communicate depends on it.
* **3. Clarity & Focus:** We value clear communication and deep work. We create an environment where complex problems can be solved with precision, free from distraction.

### Our Code of Conduct
All team members, contributors, and partners must adhere to our Code of Conduct. It is the foundation of our respectful, inclusive, and empathetic community.

* ➡️ **Full Policy:** [**`CODE_OF_CONDUCT.md`**](./CODE_OF_CONDUCT.md)

---

## 2. 🚀 Product & Engineering

This section defines *what* we build and *how* we build it.

### Our Product Philosophy
Our architecture is a **hybrid "Cloud-Factory, On-Device-Engine"** model.

We use the cloud (GCP + Firebase) as a "Factory" for the heavy computation needed to train personalized AI models. The resulting model then runs as an "Engine" 100% offline, directly on the user's device, ensuring reliability, speed, and privacy.

### Our Tech Stack
Our platform is built using modern, native, and scalable technologies.

* **Mobile (Native):** Swift (iOS) & Kotlin (Android)
* **Web Frontend:** React + TypeScript
* **Backend & AI:** Python (FastAPI)
* **Infrastructure:** GCP (Cloud Run, Vertex AI) & Firebase (Auth, Firestore, Storage)

### Engineering Workflow
All engineering work—from bug fixes to new features—follows a consistent process defined in our Contribution Guidelines. This covers our branching strategy, commit messages, and Pull Request standards.

* ➡️ **Full Policy:** [**`CONTRIBUTING.md`**](./CONTRIBUTING.md)

---

## 3. 🤝 How We Work Together

This section defines our internal operating system.

### Team Structure
Our organization is structured into several GitHub Teams, each with a clear focus. New members will be added to the appropriate teams during onboarding.

* **`@HearMeTech/admins`**: Keys from the Kingdom. (Organization owners).
* **`@HearMeTech/auditors`**: Can see everything. (Read-only access to all repositories for compliance/review).
* **`@HearMeTech/ai-ml-team`**: AI and ML. (Core model development, training pipelines).
* **`@HearMeTech/backend-dev`**: Backend developers. (API development, cloud functions, infrastructure).
* **`@HearMeTech/frontend-dev`**: Frontend developers. (Web applications, React).
* **`@HearMeTech/ios-dev`**: iOS native development (Swift).
* **`@HearMeTech/android-dev`**: Android native developments (Kotlin).

### Communication
We are an **"asynchronous-by-default"** company. We respect deep work and protect our focus. Our policy outlines which tools to use (Slack, GitHub, Email, Meet) and the etiquette for each.

* ➡️ **Full Policy:** [**`COMMUNICATION_POLICY.md`**](./COMMUNICATION_POLICY.md)

### Company Rhythms
* **Sprints:** We work in 2-week sprints.
* **Meetings:** Sprint Planning, Weekly Demos, Retrospectives.
* **1-on-1s:** Weekly 30-minute check-ins with your team lead.

---

## 4. 🔒 Operations & Security

This section covers our key policies for safety and professional conduct.

### Security
Protecting our users' data is our highest priority. All team members are responsible for upholding our security standards.

* **Internal Security:** All team members must use 2FA on all accounts (especially GitHub) and a secure password manager.
* **Reporting Vulnerabilities:** If you discover a potential security vulnerability, do not discuss it publicly. Follow the private reporting process.
* ➡️ **Full Policy:** [**`SECURITY.md`**](./SECURITY.md)

### People Operations (HR)
*(Placeholder: This section will contain all non-technical company policies.)*
* **Time Off Policy:** (e.g., How to request vacation, sick leave).
* **Equipment Policy:** (e.g., Laptop provisioning, software).
* **Onboarding:** New hires start here.
    * ➡️ **Checklist:** [**`ONBOARDING.md`**](./ONBOARDING.md)
