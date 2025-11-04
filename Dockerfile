# === Phase 1a: AI Command Center DevBox ===
#
# This Dockerfile builds our all-in-one development environment.
# It includes Git, Node.js, and both the Gemini and Claude CLIs.

# 1. Start from a stable, common base
FROM ubuntu:22.04

# 2. Set environment variables to avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# 3. Install base dependencies (git, python, npm)
# We add 'curl' and 'gnupg' to install Node.js/npm
RUN apt-get update && apt-get install -y \
    git \
    curl \
    gnupg \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# 4. Install Node.js v20 (required for the AI CLIs)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# 5. Install the AI CLI "Workers"
RUN npm install -g @google/gemini-cli
RUN npm install -g @anthropic-ai/claude-code

# 6. Create a non-root user (for security and permissions)
# This prevents our container from running as 'root'
RUN useradd -m -s /bin/bash dev

# 7. Switch to our new non-root user
USER dev

# 8. Set the default working directory
WORKDIR /home/dev/projects

# 9. Set the default command (this just keeps the container running)
CMD ["tail", "-f", "/dev/null"]
