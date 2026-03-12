if [ -f "$HOME/.gemini/settings.json" ]; then
    # Ensure sandbox is disabled in settings.json
    SETTINGS="$HOME/.gemini/settings.json"
    if command -v jq &>/dev/null; then
        jq '.tools.sandbox = false' "$SETTINGS" > "${SETTINGS}.tmp" && mv "${SETTINGS}.tmp" "$SETTINGS"
    fi

    # Install Gemini CLI
    npm install -g @google/gemini-cli@latest

    # Verify installation
    VERSION=$(gemini --version 2>&1)
    if [ $? -ne 0 ]; then
        echo "[FAILED] Failed to execute 'gemini --version'. Please check the installation."
        exit 1
    fi
    echo "Gemini CLI version: $VERSION"

    # Test gemini command
    echo ""
    echo "Testing gemini command..."
    TEST_FILE="GEMINI_TEST_DONE"
    rm -f "$TEST_FILE"

    timeout 30 gemini --yolo -p "create an empty file named \`$TEST_FILE\` in the current directory" < /dev/null

    if [ -f "$TEST_FILE" ]; then
        echo "[OK] gemini command executed successfully"
        rm -f "$TEST_FILE"
    else
        echo "[FAILED] gemini command did not create the test file"
        exit 1
    fi

    echo ""
    echo "[SUCCESS] Gemini CLI installation and configuration verified successfully!"
    echo " ✓ gemini command working"
else
    echo "[SKIP] Gemini CLI: ~/.gemini/settings.json not found. Skipping installation."
fi
