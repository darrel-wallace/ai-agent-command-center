# Project Case Study: AI Agent Command Center (Centralized DevOps Workflow)

### Executive Summary

* **The Problem:** Traditional AI workflows force the user (the "Team Lead") to manually juggle multiple disconnected tools—web chat for strategy, local CLIs for execution, and separate terminals for Git. This is inefficient, non-persistent, and fails to demonstrate crucial cloud engineering skills.
* **The Solution:** I architected a multi-device, centralized **DevOps Command Center** using established industry tools. The architecture separates the project into a consistent **Remote Dev Environment (Phase 1)** and a portfolio-ready **Serverless Cloud Agent (Phase 2)**.
* **The Outcome:** A resilient, professional, and cost-optimized workflow accessible from any laptop. This project directly demonstrates advanced skills in **Systems Architecture, Dockerization, Infrastructure as Code (IaC), and Cloud Resource Optimization.**

---

## Phase 1: The Centralized Dev Environment

**(STATUS: 100% COMPLETE)**

This phase established a single, consistent development environment by migrating local tools to an always-on Unraid Docker container, resolving the multi-device and persistence problem.

### Key Technologies Used:
* **Docker/Unraid:** Hosting and isolation for the central dev environment.
* **VS Code Remote - SSH:** Connecting the laptop UI to the remote container engine.
* **AI Tooling:** Gemini CLI & Claude Code (installed within the container).

---

## Phase 2: The Serverless AI Agent on AWS (The Portfolio Project)

**(STATUS: Starting Now)**

This phase builds the high-value, resume-ready **cloud application** that integrates four advanced **Cloud Resume Challenge (CRC) Mods**.

### IaC Tool Selected: **AWS SAM (Serverless Application Model)**

| Integrated Mod | Skill Demonstrated | Component |
| :--- | :--- | :--- |
| **Automation Nation** | IaC for Front End & CI/CD | S3, CloudFront deployment. |
| **Check Your Privilege**| **Security:** Least Privilege on IAM | Lambda IAM Roles. |
| **Monitor Lizard** | **Observability:** Monitoring & Alerting | CloudWatch Alarms on Lambda errors/latency. |
| **All The World's A Stage**| **CI/CD Maturity:** Multi-Stage Pipeline | Separate **Test** and **Production** AWS environments. |

### Key Mitigations:
* **Cost:** Designed for **AWS Always Free Tier** (Lambda/API Gateway).
* **Security:** Implemented **API Throttling** and will use **IAM Authentication**.
* **Resilience:** Lambda code will include **Exponential Backoff** for external API calls (Gemini API).
