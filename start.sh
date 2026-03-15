#!/bin/bash

# Navigate to the directory where the script is located
cd "$(dirname "$0")"

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
