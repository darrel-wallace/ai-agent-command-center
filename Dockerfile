# === Phase 1: AI Command Center DevBox (FINAL) ===
#
# Builds the environment with Git, Node, AI CLIs, and AWS/SAM CLIs (Non-Root).

# 1. Start from a stable base
FROM ubuntu:22.04

# 2. Set environment variables to avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# 3. Install core dependencies and essential utilities
RUN apt-get update && apt-get install -y \
    git \
    curl \
    gnupg \
    python3-pip \
    nano \
    less \
    zip \
    unzip \
    tree \
    && rm -rf /var/lib/apt/lists/*

# 4. Install Node.js v20 (required for the AI CLIs)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# 5. Install the AI CLI "Workers"
RUN npm install -g @google/gemini-cli \
    && npm install -g @anthropic-ai/claude-code

# 6. Install AWS CLI (using official zip installer for stability)
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install -i /usr/local/aws-cli -b /usr/local/bin \
    && rm -rf awscliv2.zip aws/

# 7. Install AWS SAM CLI (using Python pip, which is the standard method)
RUN pip3 install --upgrade aws-sam-cli

# 8. Create a non-root user (for security and permissions)
RUN useradd -m -s /bin/bash -u 1000 dev

# 9. Switch to our new non-root user
USER dev

# 10. Set the default working directory
WORKDIR /home/dev/projects

# 11. Set the default command (this just keeps the container running)
CMD ["tail", "-f", "/dev/null"]
