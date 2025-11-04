#!/usr/bin/env bash

# This script installs the necessary environment for the project.

# Download and install Bun:
curl -fsSL https://bun.sh/install | bash

# Add Bun to PATH for the current session
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Verify Bun version:
bun --version

# Install the project
bun install
bun run build:stdio
