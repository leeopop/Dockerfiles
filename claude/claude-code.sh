# Install Claude Code CLI
curl -fsSL https://claude.ai/install.sh | bash -s stable

# Add claude to PATH
export PATH="$HOME/.local/bin:$HOME/.claude/bin:$PATH"
# Add Claude Code CLI to PATH in profile
PROFILE="${PROFILE:-$HOME/.profile}"
if ! grep -Fxq 'export PATH="$HOME/.local/bin:$HOME/.claude/bin:$PATH"' "$PROFILE" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$HOME/.claude/bin:$PATH"' >> "$PROFILE"
fi

# Verify installation
VERSION=$(claude --version 2>&1)
if [ $? -ne 0 ]; then
    echo "[FAILED] Failed to execute 'claude --version'. Please check the installation."
    exit 1
fi
echo "Claude Code version: $VERSION"
