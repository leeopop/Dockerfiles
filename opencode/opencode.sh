# Install OpenCode CLI
curl -fsSL https://opencode.ai/install | bash

# Reload shell configuration
export PATH="$HOME/.opencode/bin:$PATH"

AUTH_FILE="$HOME/.local/share/opencode/auth.json"

# Get available models
MODELS=$(opencode models < /dev/null 2>&1)

if [ $? -ne 0 ]; then
    echo "[FAILED] Failed to execute 'opencode models'. Please check the installation."
    exit 1
fi

# Count total models
MODEL_COUNT=$(echo "$MODELS" | wc -l)
echo "Found $MODEL_COUNT models available"

# Test opencode run command for each configured provider
echo ""
echo "Testing opencode run command..."
COMMAND_CHECK=1
TEST_COUNT=0

if [ ! -f "$AUTH_FILE" ]; then
    echo "[FAILED] Auth file not found: $AUTH_FILE"
    exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
    echo "[FAILED] jq is not installed. Please check the image configuration."
    exit 1
fi

if ! jq empty "$AUTH_FILE" >/dev/null 2>&1; then
    echo "[FAILED] Auth file is not valid JSON: $AUTH_FILE"
    exit 1
fi

run_model_test() {
    provider="$1"
    model="$2"
    test_file="$3"

    TEST_COUNT=$((TEST_COUNT + 1))
    echo ""
    echo "Testing provider '$provider' with model '$model'..."

    rm -f "$test_file"
    timeout 30 opencode run --model "$model" "create an empty file named \`$test_file\` in the current directory" < /dev/null

    if [ -f "$test_file" ]; then
        echo "[OK] opencode run command executed successfully for '$provider'"
        rm -f "$test_file"
    else
        echo "[FAILED] opencode run command did not create the test file for '$provider'"
        COMMAND_CHECK=0
    fi
}

if jq -e 'has("openai")' "$AUTH_FILE" >/dev/null 2>&1; then
    run_model_test "openai" "openai/gpt-5.4" "OPENCODE_TEST_OPENAI_DONE"
fi

if jq -e 'has("anthropic")' "$AUTH_FILE" >/dev/null 2>&1; then
    run_model_test "anthropic" "anthropic/claude-opus-4-7" "OPENCODE_TEST_ANTHROPIC_DONE"
fi

if [ "$TEST_COUNT" -eq 0 ]; then
    echo "[FAILED] No supported auth providers found in $AUTH_FILE"
    exit 1
fi


# Final verification
if [ $COMMAND_CHECK -eq 1 ]; then
    echo ""
    echo "[SUCCESS] OpenCode installation and configuration verified successfully!"
    echo " ✓ opencode run command working"
else
    echo ""
    echo "[WARNING] OpenCode verification incomplete."
    if [ $COMMAND_CHECK -eq 0 ]; then
        echo " ✗ Failed: opencode run command test"
    fi
    exit 1
fi
