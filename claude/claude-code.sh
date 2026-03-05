if [ -f "$HOME/.claude/.credentials.json" ]; then
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

    # Test claude command
    echo ""
    echo "Testing claude command..."
    TEST_FILE="CLAUDE_TEST_DONE"
    rm -f "$TEST_FILE"

    timeout 30 claude -p "create an empty file named $TEST_FILE in the current directory" --allowedTools "Bash" < /dev/null

    if [ -f "$TEST_FILE" ]; then
        echo "[OK] claude command executed successfully"
        rm -f "$TEST_FILE"
    else
        echo "[FAILED] claude command did not create the test file"
        exit 1
    fi

    echo ""
    echo "[SUCCESS] Claude Code installation and configuration verified successfully!"
    echo " ✓ claude command working"
else
    echo "[SKIP] Claude Code: ~/.claude/.credentials.json not found. Skipping installation."
fi
