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

We are now ready to proceed to **Phase 1b:** Deploying this container on the Unraid server.
