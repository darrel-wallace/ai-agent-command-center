# AI Command Center - Pivoted Project Plan (as of Nov 9, 2025)

## 1. The Pivot (The "Why")

Based on a "Senior Architect" (Claude) critique, we identified and corrected two critical issues:

1.  **Fatal Flaw:** The official VS Code AI extensions (Gemini, Claude) are hard-coded to their cloud APIs and **cannot be re-pointed** to a custom MCP server on Unraid. Building a custom VS Code extension to do this is a massive, separate project.
2.  **Portfolio Gap:** The original plan was based on a "Home Lab" (Unraid), but the portfolio goal is an "AI **Cloud** Engineer" role. This is a disconnect.

As a result, we have pivoted to a new, two-phased plan.

---

## 2. Phase 1: The Professional Dev Environment (COMPLETED)

* **Goal:** Solve the immediate problem of having a single, consistent development environment on all 3 laptops.
* **Architecture:** Use **VS Code's built-in "Remote - SSH"** feature.
* **The "Engine":** A **Docker container on the Unraid server** will host the dev environment.
* **Tools in Container:** The container will have `git`, `python`, `gemini-cli`, and `claude-cli` pre-installed.
* **Workflow:** This is our new "Command Center." I (the "Team Lead") will work inside VS Code, remoted into this container. I can still run both AI CLIs manually in the integrated terminal, guided by my "PM" (Gemini). This solves the multi-device problem.

### Build Log: Phase 1a - Local DevBox Prototype
*(Details documenting creation of Dockerfile and docker-compose.yml)*

### Build Log: Phase 1b - Deploy DevBox to Unraid Server
*(Details documenting SSH hardening, key setup, and docker run execution on Unraid)*

### Build Log: Phase 1c - Connect Command Center (VS Code)
*(Details documenting successful VS Code connection to the remote container via SSH)*

---

## 3. Phase 2: The "AI Cloud Engineer" Portfolio Project

* **Goal:** Build the true, high-value portfolio project that demonstrates cloud-native skills.
* **IaC Tool Selected:** **AWS SAM (Serverless Application Model)**.
* **Architecture:** A **100% serverless AI agent** built on **AWS**.
    * The "Engine": An **AWS Lambda** function (Python) that calls the Gemini API to perform research tasks.
    * The "Trigger": An **Amazon API Gateway** that invokes the Lambda.
    * The "Storage": An **Amazon S3 Bucket** where the Lambda saves the `.md` research files.

### Finalized Architecture and Integrated CRC Mods

| Mod Category | Skill Demonstrated | Project Component |
| :--- | :--- | :--- |
| **Automation Nation** | **IaC for Front End:** Deploying the entire static site using SAM/CloudFormation. | Front-end S3 bucket, CloudFront, Route 53 (DNS). |
| **Check Your Privilege** | **Security:** Implementing the Principle of Least Privilege on IAM roles. | IAM Policy validation, removing unused permissions. |
| **Monitor Lizard** | **Observability:** Setting up automated monitoring and alerting. | CloudWatch Alarms on Lambda errors/latency, publishing to SNS. |
| **All The World's A Stage**| **CI/CD Maturity:** Implementing a multi-stage deployment pipeline. | Separate **Test** and **Production** environments on AWS. |

### Key Mitigations for Phase 2 (from Claude's critique):

* **Cost:** The entire architecture will be designed to fit within the **AWS "Always Free" Tier**. We will also implement **AWS Budget Alerts** and **API Gateway Throttling** as financial safeguards.
* **Security:** The API Gateway will **not** be public. It will be secured using (at minimum) **API Keys** or, preferably, **IAM Authentication**.
* **Rate Limits:** The Lambda function will be engineered to handle the Gemini API's free tier rate limits by implementing **exponential backoff with retries**.
* **IaC:** This entire Phase 2 project *must* be deployed using **Infrastructure as Code** to be a valid portfolio piece.

### Next Steps (Starting Now)

| Step | Goal | Details |
| :--- | :--- | :--- |
| **1. AWS Prep** | **Secure Credentials** | Configure the DevBox container for secure AWS access. |
| **2. Code Setup** | **Create SAM Template** | Write the initial SAM template (YAML/CloudFormation). |
| **3. Lambda Core** | **Draft Python Code** | Write the core Python function (`boto3`, Gemini API, error handling). |
| **4. Deploy Test** | **First Deployment** | Deploy the stack to a separate **Test** environment. |
