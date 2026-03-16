#!/bin/bash

# Resolve script directory (absolute path)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# Repo root is one level up from this script directory
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

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

# Navigate to the repo root so we always use the root env + setup.py
cd "$ROOT_DIR"

echo "=========================================="
echo "    Chatterbox Toolkit UI Launcher"
echo "=========================================="

# Check if the virtual environment exists in the repo root
if [ ! -d "$ROOT_DIR/toolkit" ]; then
    echo "[*] Virtual environment not found. Creating 'toolkit'..."
    python3 -m venv "$ROOT_DIR/toolkit"
    echo "[+] Virtual environment created successfully."
else
    echo "[*] Virtual environment 'toolkit' already exists."
fi

# Activate the virtual environment from the repo root
echo "[*] Activating virtual environment..."
source "$ROOT_DIR/toolkit/bin/activate"

# Run the setup script (which will install dependencies and launch the UI)
echo "[*] Running setup.py from $ROOT_DIR..."
python "$ROOT_DIR/setup.py"

# Deactivate when done
deactivate
