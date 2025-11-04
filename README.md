# Project Case Study: AI-Agent Command Center

### Executive Summary

* **The Problem:** Modern AI workflows are disjointed. A "Team Lead" (the user) must manually copy-paste information between multiple, separate tools: a strategic chat AI (like Gemini), a code-focused AI (like Claude Code), a terminal (for `git` commands), and a code editor (like VS Code). This is inefficient, error-prone, and not scalable, especially when working across multiple devices.
* **The Solution:** I architected and built a centralized, secure "command center" to orchestrate a multi-model, multi-tool AI workflow. This system uses a local Unraid server as the "engine" and VS Code as the "dashboard," allowing me to securely manage all my tools and AI workers from a single, consistent interface on any of my devices.
* **The Outcome:** A seamless, professional workflow where I (as the "Team Lead") can manage my "Project Manager" AI, my "Senior Dev" AI, and my "Junior Dev" AI from one chat panel. The AI "PM" can now securely execute `git` commands, read/write files, and orchestrate other AI models on my central server, all with my explicit permission.

---

### System Architecture

This system is built on a client-server model:

1.  **The "Engine" (Unraid Server):** A Docker container running on Unraid hosts the central **MCP (Model Context Protocol) Server**. This "bridge" container has access to all the project files and "tools" (Git, Gemini CLI, Claude Code).
2.  **The "Secure Connection" (VPN/Twingate):** A secure network layer (e.g., WireGuard or Twingate) ensures that my "engine" is only accessible to me, whether I'm at home or working remotely. This prevents unauthorized access to my local AI tools.
3.  **The "Dashboard" (VS Code):** On any of my laptops, VS Code acts as the "command center." Its AI chat extension (the "Host") is configured to connect to my secure Unraid server's IP address instead of the public cloud.
4.  **The "Workforce" (AI Models):**
    * **AI Project Manager (Gemini API):** The main AI in the VS Code chat, which now has access to the MCP server's "tools" (e.g., `run_shell_command`, `read_file`).
    * **AI Workers (Gemini/Claude CLIs):** Tools that the "PM" can call via the `run_shell_command` tool to perform specialized tasks like research or analysis.

### Key Technologies Used

* **Unraid (or any Docker host):** For running the central server.
* **Docker:** To containerize and isolate the MCP server and its tools.
* **MCP (Model Context Protocol):** The open-source "bridge" standard.
* **VPN (WireGuard) / Zero-Trust (Twingate):** For secure remote access.
* **VS Code:** The "command center" interface (the MCP "Host").
* **AI Models:** Gemini API, Gemini CLI, Claude Code.
* **Git:** As a core, AI-managed tool for version control.

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

We are now ready to proceed to **Phase 1b:** Deploying this container on the Unraid server.
