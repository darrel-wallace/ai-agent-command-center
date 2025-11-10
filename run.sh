#!/bin/bash
#
# This script stops, removes, and re-runs the "devbox" container
# with all persistent volumes and settings.

# 1. Stop and remove any old "devbox" container
echo "--- Stopping and removing old 'devbox' container (if it exists)... ---"
docker stop devbox
docker rm devbox

# 2. Run the new "devbox" container
echo "--- Starting new 'devbox' container... ---"
docker run \
    -d \
    --name devbox \
    -v /mnt/user/projects:/home/dev/projects \
    -v /root/.ssh:/home/dev/.ssh:ro \
    -v devbox-home:/home/dev \
    -it \
    devbox:latest

echo "--- ✅ 'devbox' container is now running! ---"
