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
AUTH_AVAILABLE=1

if [ ! -f "$AUTH_FILE" ]; then
    echo "[INFO] Auth file not found: $AUTH_FILE"
    echo "[INFO] Falling back to default OpenCode free model (no --model option)."
    AUTH_AVAILABLE=0
else
    if ! command -v jq >/dev/null 2>&1; then
        echo "[FAILED] jq is not installed. Please check the image configuration."
        exit 1
    fi

    if ! jq empty "$AUTH_FILE" >/dev/null 2>&1; then
        echo "[FAILED] Auth file is not valid JSON: $AUTH_FILE"
        exit 1
    fi
fi

run_model_test() {
    test_file="$1"
    provider="$2"
    model="$3"

    TEST_COUNT=$((TEST_COUNT + 1))
    echo ""
    if [ -n "$model" ]; then
        echo "Testing provider '$provider' with model '$model'..."
    else
        echo "Testing provider '$provider' with default OpenCode model (no --model option)..."
    fi

    rm -f "$test_file"
    set --
    if [ -n "$model" ]; then
        set -- --model "$model"
    fi
    timeout 30 opencode run "$@" "create an empty file named \`$test_file\` in the current directory" < /dev/null

    if [ -f "$test_file" ]; then
        echo "[OK] opencode run command executed successfully for '$provider'"
        rm -f "$test_file"
    else
        echo "[FAILED] opencode run command did not create the test file for '$provider'"
        COMMAND_CHECK=0
    fi
}

if [ "$AUTH_AVAILABLE" -eq 1 ]; then
    if jq -e 'has("openai")' "$AUTH_FILE" >/dev/null 2>&1; then
        run_model_test "OPENCODE_TEST_OPENAI_DONE" "openai" "openai/gpt-5.4"
    fi

    if jq -e 'has("anthropic")' "$AUTH_FILE" >/dev/null 2>&1; then
        run_model_test "OPENCODE_TEST_ANTHROPIC_DONE" "anthropic" "anthropic/claude-opus-4-7"
    fi
else
    run_model_test "OPENCODE_TEST_DEFAULT_DONE" "default"
fi

if [ "$TEST_COUNT" -eq 0 ]; then
    if [ "$AUTH_AVAILABLE" -eq 1 ]; then
        echo "[INFO] No supported auth providers found in $AUTH_FILE"
        echo "[INFO] Falling back to default OpenCode free model (no --model option)."
    fi
    run_model_test "OPENCODE_TEST_DEFAULT_DONE" "default"
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
