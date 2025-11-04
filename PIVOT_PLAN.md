# AI Command Center - Pivoted Project Plan (as of Nov 4, 2025)

## 1. The Pivot (The "Why")

Based on a "Senior Architect" (Claude) critique on our initial `README.md` brief, we identified two critical issues:

1.  **Fatal Flaw:** The official VS Code AI extensions (Gemini, Claude) are hard-coded to their cloud APIs and **cannot be re-pointed** to a custom MCP server on Unraid. Building a custom VS Code extension to do this is a massive, separate project.
2.  **Portfolio Gap:** The original plan was based on a "Home Lab" (Unraid), but the portfolio goal is an "AI **Cloud** Engineer" role. This is a disconnect.

As a result, we have pivoted to a new, two-phased plan.

---

## 2. Phase 1: The Professional Dev Environment (The Immediate Win)

* **Goal:** Solve the immediate problem of having a single, consistent development environment on all 3 laptops.
* **Architecture:** Use **VS Code's built-in "Remote - SSH"** feature.
* **The "Engine":** A **Docker container on the Unraid server** will host the dev environment.
* **Tools in Container:** The container will have `git`, `python`, `gemini-cli`, and `claude-cli` pre-installed.
* **Workflow:** This is our new "Command Center." I (the "Team Lead") will work inside VS Code, remoted into this container. I can still run both AI CLIs manually in the integrated terminal, guided by my "PM" (Gemini). This solves the multi-device problem.
* **Immediate Next Step:** Build a `Dockerfile` and `docker-compose.yml` for this "DevBox" locally on one machine first (Phase 1a).

---

## 3. Phase 2: The "AI Cloud Engineer" Portfolio Project

* **Goal:** Build the true, high-value portfolio project that demonstrates cloud-native skills.
* **Architecture:** A **100% serverless AI agent** built on **AWS**.
* **The "Engine":** An **AWS Lambda** function (Python) that calls the Gemini API to perform research tasks.
* **The "Trigger":** An **Amazon API Gateway** that invokes the Lambda.
* **The "Storage":** An **Amazon S3 Bucket** where the Lambda saves the `.md` research files.

### Key Mitigations for Phase 2 (from Claude's critique):

* **Cost:** The entire architecture will be designed to fit within the **AWS "Always Free" Tier**. We will also implement **AWS Budget Alerts** and **API Gateway Throttling** as financial safeguards.
* **Security:** The API Gateway will **not** be public. It will be secured using (at minimum) **API Keys** or, preferably, **IAM Authentication**.
* **Rate Limits:** The Lambda function will be engineered to handle the Gemini API's free tier rate limits by implementing **exponential backoff with retries**.
* **IaC:** This entire Phase 2 project *must* be deployed using **Infrastructure as Code** (e.g., Terraform or AWS SAM) to be a valid portfolio piece.
