# AI Command Center - Comprehensive Build Log & Execution History

---

## Phase 1: The Professional Dev Environment

### Phase 1a: Local DevBox Prototype (Laptop Build)

**Goal:** Verify Dockerfile and Compose structure before remote deployment.

| Log Item | Output/Command | Notes |
| :--- | :--- | :--- |
| **Dockerfile Base** | `FROM ubuntu:22.04` | Confirmed reliable base for core dev tools. |
| **Tool Installs** | `npm install -g @google/gemini-cli` / `@anthropic-ai/claude-code` | Success. Required installing Node.js v20+ via `curl` first. |
| **Permissions Error** | `permission denied while trying to connect to the Docker daemon` | **Initial Failure:** User was not in the `docker` group. |
| **Fix 1** | `sudo groupadd docker` / `sudo usermod -aG docker ${USER}` | Created necessary Linux group and added user. Required logout/reboot. |
| **Final Test** | `docker-compose up -d --build` | **SUCCESS.** Confirmed container built and ran locally without `sudo`. |

---

### Phase 1b: Deploy DevBox to Unraid Server

**Goal:** Establish a secure, persistent, and multi-device connection point.

| Log Item | Output/Command | Notes |
| :--- | :--- | :--- |
| **Initial SSH Check** | `ls /boot/config/ssh/sshd_config` | File not found. Confirmed need to create persistent config. |
| **Password Disable** | `PasswordAuthentication no` | Edit made to `/boot/config/ssh/sshd_config` to harden security. |
| **Key Generation (Unraid)** | `ssh-keygen -t ed25519 -C "unraid-tower-key"` | Created unique key for the server's GitHub access. |
| **Key Deployment (Unraid)** | `echo "ssh-ed25519 ..." >> authorized_keys` | Added public key to Unraid's allowed list for passwordless login. |
| **Key Management (GitHub)** | (Manual Step) | New Unraid public key added to GitHub. |
| **Project Share** | `/mnt/user/projects` | New Unraid share created and set to `Prefer` cache drive for speed. |
| **Git Clone Error** | (Attempt to `git clone` failed) | **Error:** Unraid did not have GitHub authorization. |
| **Compose Command Error** | `-bash: docker-compose: command not found` | **Error:** Docker version required `docker compose` (with space). |
| **Compose Flag Error** | `unknown flag: --build` | **Error:** Unraid's simplified `docker compose` did not support common flags. |
| **Final Run Command** | `docker build -t devbox:latest .` then `./run.sh` | **SUCCESS.** Bypassed custom wrapper with manual Docker commands. |

---

### Phase 1c: Connect Command Center (VS Code)

**Goal:** Establish a persistent VS Code connection to the running container.

| Log Item | Output/Command | Notes |
| :--- | :--- | :--- |
| **WSL Connection** | VS Code Remote - Containers failed to detect Docker. | **Fix:** Connected VS Code to WSL first (`> Connect to WSL`). |
| **SSH Config** | `Host unraid-devbox` / `User root` / `HostName <IP>` | Added to local laptop's `~/.ssh/config` file. |
| **SSH Test** | `ssh root@<IP>` | **SUCCESS.** Confirmed key-based login from laptop to Unraid. |
| **Final Connection** | `Remote Explorer > Attach to Container` | **SUCCESS.** Established the multi-layered connection (Windows > WSL > SSH > Docker) to the DevBox. |
| **Model Downgrade** | `hit a usage limit for 2.5 pro and am now on 2.5 flash model` | **Observed:** Confirmed free-tier model capacity and successful automatic failover to the Flash model. |

### Final Build Log & Outcome: Tools Installed

The DevBox image was successfully finalized, including all necessary tools:

* **AWS CLI & SAM CLI:** Installed using official installers/pip, preparing for Phase 2 IaC deployment.
* **Nano/Utilities Fix:** We solved the `command not found` error by manually attaching as `root` (using `docker exec -it -u root devbox /bin/bash`) and installing `nano`, `less`, `zip`, `unzip`, and `tree` using `apt update` and `apt install`.
* **Result:** The DevBox is now running with the correct, least-privilege configuration, fully equipped for both AI and AWS work.
