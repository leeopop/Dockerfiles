# Install OpenCode CLI
curl -fsSL https://opencode.ai/install | bash

# Reload shell configuration
export PATH="$HOME/.opencode/bin:$PATH"

# Get available models
MODELS=$(opencode models < /dev/null 2>&1)

if [ $? -ne 0 ]; then
    echo "[FAILED] Failed to execute 'opencode models'. Please check the installation."
    exit 1
fi

# Count total models
MODEL_COUNT=$(echo "$MODELS" | wc -l)
echo "Found $MODEL_COUNT models available"

# Test opencode run command
echo ""
echo "Testing opencode run command..."
TEST_FILE="OPENCODE_TEST_DONE"
rm -f "$TEST_FILE" # Remove if exists from previous run

timeout 10 opencode run "create an empty file named $TEST_FILE" < /dev/null

# Check if test file was created
if [ -f "$TEST_FILE" ]; then
    echo "[OK] opencode run command executed successfully"
    COMMAND_CHECK=1
    rm -f "$TEST_FILE" # Clean up test file
else
    echo "[FAILED] opencode run command did not create the test file"
    COMMAND_CHECK=0
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
