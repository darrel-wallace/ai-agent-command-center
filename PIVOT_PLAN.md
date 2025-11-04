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


---

## Build Log: Phase 1a - Local DevBox Prototype

This phase served as a successful proof-of-concept to build our "DevBox" locally before attempting to deploy it on the Unraid server.

### 1. The Blueprint (`Dockerfile`)

We created a `Dockerfile` based on an `ubuntu:22.04` image. This file defines the container's environment by:
* Installing all base dependencies (`git`, `python3-pip`, `npm`, `curl`).
* Installing both the `@google/gemini-cli` and `@anthropic-ai/claude-code` CLIs globally via `npm`.
* Creating a non-root user named `dev` for security and to prevent permissions issues.
* Setting the default working directory to `/home/dev/projects`.

### 2. The Build Instructions (`docker-compose.yml`)

We created a `docker-compose.yml` file to manage the container's runtime configuration. This file is critical as it solves our persistence and access problems:
* **Project Files:** It mounts the host's `~/projects` directory into the container's `/home/dev/projects` directory.
* **SSH Keys:** It mounts the host's `~/.ssh` directory as `read-only` into the container, allowing `git` inside the container to securely authenticate with GitHub.
* **Persistence:** It defines a named volume (`devbox-home`) and mounts it to the container's `/home/dev` directory. This ensures that any config files (`.gitconfig`), shell history (`.bash_history`), or credentials we create inside the container are **persistent and survive a reboot.**

### 3. Troubleshooting & Connection

* **Problem:** Encountered a `permission denied` error when attempting to run `docker-compose` due to the `fragsrus` user not being in the `docker` group.
* **Solution:** We created the `docker` group (`sudo groupadd docker`) and added the user to it (`sudo usermod -aG docker ${USER}`), which resolved all permission errors after a reboot.
* **Problem 2:** VS Code on the Windows host could not see the Docker container running inside the WSL 2 guest.
* **Solution 2:** We used the **Remote Development** extension pack, first to **"Connect to WSL,"** and *then* from that new window, we used the **"Attach to Container"** command.

### 4. Phase 1a Outcome

We successfully built the `devbox` container and attached to it from VS Code. We have a fully functional, isolated development environment running in Docker, complete with all our AI tools and `git` access.

---

## Build Log: Phase 1b - Deploy DevBox to Unraid Server

This phase involved migrating our local "DevBox" prototype to a persistent, 24/7 container on the Unraid server.

### 1. Secure Unraid SSH Access

Before connecting VS Code, we had to harden the server's SSH.
* **Action:** Navigated to `Settings > Management Access` in the Unraid GUI.
* **Configuration:** SSH was enabled, but password authentication was on by default.
* **Hardening:** We created a persistent SSH config file at `/boot/config/ssh/sshd_config` and set `PasswordAuthentication no`.
* **Key Setup (Laptops):** We added our laptop's public SSH key (`~/.ssh/id_ed25519.pub`) to the Unraid server's `authorized_keys` file (`/boot/config/ssh/authorized_keys`).
* **Test:** We successfully restarted the Unraid SSH service (`/etc/rc.d/rc.sshd restart`) and confirmed we could log in from our laptop's WSL terminal using only the SSH key.

### 2. Deploy Project Files to Unraid

* **Problem:** The Unraid server needed its own GitHub credentials to `git clone` the project.
* **Solution:** We generated a new SSH keypair *on the Unraid server* (`ssh-keygen -t ed25519 -C "unraid-tower-key"`), added the new public key to GitHub, and then successfully ran `git clone git@github.com:darrel-wallace/ai-agent-command-center.git`.

### 3. Configure the Container for Unraid

* **Share Setup:** We created a new Unraid share named `projects` and set its cache pool to `Prefer` to ensure it runs on the fast SSD cache drive.
* **Compose File Edit:** We edited the `docker-compose.yml` file on the Unraid server. We changed the project volume mapping from the local laptop path to the new Unraid share path: `- /mnt/user/projects:/home/dev/projects`.

### 4. Build & Run the Container

* **Problem 1:** The `docker-compose` (with hyphen) command was not found.
* **Solution 1:** We used the modern `docker compose` (with space) command, which is built into the new Docker version.
* **Problem 2:** The Unraid version of `docker compose` was a non-standard wrapper and did not accept the `-d` or `--build` flags.
* **Solution 2 (The "Manual" Build):** We abandoned `docker compose` and used the core `docker` commands:
    1.  **Build:** We successfully built the image from our `Dockerfile` using `docker build -t devbox:latest .`.
    2.  **Script:** We created a reusable `run.sh` script to stop/remove old containers and launch the new `devbox:latest` image with all the correct volume mounts (`/mnt/user/projects`, `/root/.ssh`, and `devbox-home`).
    3.  **Launch:** We ran `./run.sh` to start the container.

### 5. Phase 1b Outcome

---

## Build Log: Phase 1c - Connect Command Center (VS Code)

This phase completed the centralized development environment by linking the local VS Code client to the remote Docker container, thus solving the multi-device problem.

### 1. SSH Configuration and Connection

* **Action:** We configured the local VS Code client to securely access the Unraid server using the pre-existing SSH keys.
* **Method:** We added the Unraid server as an SSH Target in the VS Code "Remote Explorer" using the server's local IP address and the `root` user (`root@<IP>`).
* **Platform Select:** VS Code correctly identified the target as a **Linux** environment.

### 2. Container Attachment

* **Action:** Once connected to the Unraid host via SSH, we used the VS Code Remote Explorer to view the running Docker containers.
* **Result:** We successfully used the **"Attach to Container"** command to open a new VS Code window.
* **Final State:** The new window operates entirely inside the `devbox` container, providing a terminal with all tools (`git`, `gemini-cli`, `claude-cli`) and access to the shared Unraid project files (`/mnt/user/projects`).
* **Confirmation:** The prompt `dev@<container-ID>:~$` confirmed successful login as the secure, non-root user (`dev`).

### 3. Phase 1 Conclusion

**Phase 1 is 100% complete.** The system is now a resilient, centralized, and consistent development environment accessible from any local client.

---

We successfully built and launched the `devbox` container on the Unraid server. It is now running 24/7, and we have confirmed it appears in the Unraid Docker GUI. The "engine" for our command center is officially online.
