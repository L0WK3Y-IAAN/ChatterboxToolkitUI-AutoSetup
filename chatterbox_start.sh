#!/bin/bash

# Resolve script directory (absolute path) so we can add it to PATH and cd there
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Add script directory to PATH for this session and persist for future terminals
add_to_path() {
    local rc_file
    if [[ -n "$ZSH_VERSION" ]] || [[ "$SHELL" == *zsh* ]]; then
        rc_file="$HOME/.zshrc"
    else
        rc_file="$HOME/.bashrc"
    fi
    if [[ -f "$rc_file" ]]; then
        if ! grep -q "ChatterboxToolkitUI" "$rc_file" 2>/dev/null; then
            echo "" >> "$rc_file"
            echo "# ChatterboxToolkitUI - run chatterbox_start.sh from anywhere" >> "$rc_file"
            echo "export PATH=\"$SCRIPT_DIR:\$PATH\"" >> "$rc_file"
            echo "[+] Added script directory to PATH in $rc_file — you can run this script from anywhere in new terminals."
        fi
    else
        echo "[*] No $rc_file found; adding to current session only."
    fi
    export PATH="$SCRIPT_DIR:$PATH"
}

if [[ ":$PATH:" != *":$SCRIPT_DIR:"* ]]; then
    add_to_path
fi

# Navigate to the script directory
cd "$SCRIPT_DIR"

echo "=========================================="
echo "    Chatterbox Toolkit UI Launcher"
echo "=========================================="

# Check if the virtual environment exists
if [ ! -d "toolkit" ]; then
    echo "[*] Virtual environment not found. Creating 'toolkit'..."
    python3 -m venv toolkit
    echo "[+] Virtual environment created successfully."
else
    echo "[*] Virtual environment 'toolkit' already exists."
fi

# Activate the virtual environment
echo "[*] Activating virtual environment..."
source toolkit/bin/activate

# Run the setup script (which will install dependencies and launch the UI)
echo "[*] Running setup.py..."
python setup.py

# Deactivate when done
deactivate
