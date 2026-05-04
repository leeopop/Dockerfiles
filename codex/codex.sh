# Install Codex CLI
npm i -g @openai/codex

# Verify installation
VERSION=$(codex --version 2>&1)
if [ $? -ne 0 ]; then
    echo "[FAILED] Failed to execute 'codex --version'. Please check the installation."
    exit 1
fi
echo "Codex CLI version: $VERSION"
