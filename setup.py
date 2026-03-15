#!/usr/bin/env python3
import os
import subprocess
import sys
from pathlib import Path
import textwrap

ROOT = Path(__file__).resolve().parent
VENV = ROOT / "toolkit"
SETUP_DONE_MARKER = ROOT / ".chatterbox_setup_done"

def run(cmd, **kwargs):
    print(f"[*] Running: {' '.join(cmd)}")
    subprocess.run(cmd, check=True, **kwargs)

def venv_python():
    if sys.platform == "win32":
        return str(VENV / "Scripts" / "python.exe")
    return str(VENV / "bin" / "python")

def create_venv():
    if VENV.exists():
        print("[+] Virtualenv already exists, skipping creation.")
        return
    print("[*] Creating virtualenv at", VENV)
    run([sys.executable, "-m", "venv", str(VENV)])

def install_deps():
    py = venv_python()

    run([py, "-m", "pip", "install", "-U", "pip", "wheel", "setuptools"])

    # CPU PyTorch for Mac
    run([
        py, "-m", "pip", "install",
        "torch", "torchaudio", "torchvision",
        "--extra-index-url", "https://download.pytorch.org/whl/cpu",
    ])

    # Core Python deps
    run([
        py, "-m", "pip", "install",
        "gradio==5.44.1",
        "fastapi",
        "uvicorn",
        "soundfile",
        "pydub",
        "nltk",
        "webrtcvad-wheels",
        "chatterbox-tts==0.1.6",
    ])

def ensure_nltk_data():
    py = venv_python()
    code = (
        "import nltk, pathlib; "
        "path = pathlib.Path('nltk_data'); path.mkdir(exist_ok=True); "
        "nltk.data.path.append(str(path.resolve())); "
        "nltk.download('punkt', download_dir=str(path.resolve())); "
        "nltk.download('punkt_tab', download_dir=str(path.resolve()))"
    )
    print("[*] Downloading NLTK data (punkt, punkt_tab)...")
    run([py, "-c", code])

def launch_ui():
    py = venv_python()
    print("\n[+] Launching ChatterboxToolkitUI...")
    # Inherit stdin/stdout so you see logs in the same terminal
    run([py, "ChatterboxToolkitUI.py"])

def main():
    if SETUP_DONE_MARKER.exists():
        print("[+] Setup already complete. Launching UI...")
        launch_ui()
        return

    create_venv()
    install_deps()
    ensure_nltk_data()

    SETUP_DONE_MARKER.touch()
    print("\n[+] Setup complete. Starting the UI...")
    launch_ui()

if __name__ == "__main__":
    main()
