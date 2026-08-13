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

# Choose model (base vs turbo) unless already specified via env var
if [[ -z "${CHATTERBOX_MODEL:-}" ]]; then
  echo ""
  echo "Select TTS model:"
  echo "  1) Base (ChatterboxTTS) [default]"
  echo "  2) Turbo (ChatterboxTurboTTS)"
  read -r -p "Enter choice [1-2]: " _cb_choice
  case "${_cb_choice:-1}" in
    1) export CHATTERBOX_MODEL="base" ;;
    2) export CHATTERBOX_MODEL="turbo" ;;
    *) echo "[*] Invalid choice, defaulting to Base."; export CHATTERBOX_MODEL="base" ;;
  esac
fi
echo "[*] Using CHATTERBOX_MODEL=${CHATTERBOX_MODEL}"

# Pick a Python interpreter for the venv. This project is built/tested against
# 3.11; a bare "python3" can silently resolve to whatever Homebrew most
# recently made the default (e.g. 3.12 or a brand-new 3.14). numpy==1.25.2
# (pulled in by gradio==5.44.1) only ships prebuilt wheels through Python
# 3.11 -- anything newer falls back to a source build that fails outright
# (newer Python removed pkgutil.ImpImporter, which the old setuptools/
# pkg_resources bundled with that numpy release still needs).
# Prefer 3.11 explicitly, before falling back to newer versions.
PYTHON_BIN=""
for candidate in python3.11 python3.12 python3; do
    if command -v "$candidate" >/dev/null 2>&1; then
        PYTHON_BIN="$candidate"
        break
    fi
done
if [ -z "$PYTHON_BIN" ]; then
    echo "[!] No suitable python3 interpreter found on PATH."
    exit 1
fi
echo "[*] Using Python interpreter: $(command -v "$PYTHON_BIN") ($("$PYTHON_BIN" --version 2>&1))"

# Check if the virtual environment exists in the repo root
if [ ! -d "$ROOT_DIR/toolkit" ]; then
    echo "[*] Virtual environment not found. Creating 'toolkit'..."
    "$PYTHON_BIN" -m venv "$ROOT_DIR/toolkit"
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
