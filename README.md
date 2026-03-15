# 🗣️ ChatterboxToolkit-AutoSetup

A streamlined, fully automated deployment wrapper and Web GUI for [Resemble AI's Chatterbox](https://github.com/resemble-ai/chatterbox) Text-to-Speech model.

Getting heavy local LLM/TTS models running can be a headache of dependency conflicts and virtual environment management. **ChatterboxToolkit-AutoSetup** solves this by providing one-click launch scripts that handle everything from environment creation and dependency resolution to automatically launching the Gradio UI in your browser.

## ✨ Key Features

- **🚀 True One-Click Setup:** Run `chatterbox_start.sh` or `chatterbox_start.bat`. The script creates an isolated `toolkit` virtual environment, installs PyTorch/Gradio and dependencies, downloads NLTK data, and launches the app.
- **⏭️ Smart Setup Skip:** After the first run, setup is skipped automatically. Launches go straight to the UI — no repeated installs.
- **📂 Run From Anywhere:** On first run, the scripts add their directory to your PATH (shell profile on macOS/Linux, user PATH on Windows). After that, you can run the launcher from any terminal directory.
- **🍎 Apple Silicon Native:** Automatically routes hardware acceleration to use Apple's Metal Performance Shaders (`mps`) on macOS where supported.
- **🌐 Auto-Browser Launch:** When the TTS pipeline is ready, your default browser opens the Gradio interface.
- **🎙️ Full UI Capabilities:** Gradio interface for text-to-speech, voice cloning, and tuning.

## 🛠️ Prerequisites

- **Python 3.10 or 3.11**
- **FFmpeg** (required for audio processing)
  - macOS: `brew install ffmpeg`
  - Linux: `sudo apt install ffmpeg`
  - Windows: `winget install ffmpeg`

## 🚀 Quick Start (Auto-Setup)

### macOS / Linux

Navigate to the project folder and run:

```bash
chmod +x chatterbox_start.sh
./chatterbox_start.sh
```

After the first run, you can start from anywhere:

```bash
chatterbox_start.sh
```

### Windows

Double-click `chatterbox_start.bat` or run it from Command Prompt/PowerShell in the project folder. After the first run, you can run `chatterbox_start.bat` from any directory in new terminals.

## 🔄 Re-running Setup

To force a full setup again (e.g. after removing the `toolkit/` venv or to refresh dependencies), delete the setup marker and run the launcher:

```bash
rm .chatterbox_setup_done
./chatterbox_start.sh
```

On Windows, delete `.chatterbox_setup_done` in the project folder, then run `chatterbox_start.bat` again.

## 📁 Project Structure

- `chatterbox_start.sh` / `chatterbox_start.bat` — One-click launchers (create venv, run setup, launch UI).
- `setup.py` — Creates the `toolkit` venv, installs dependencies, downloads NLTK data, then starts the UI. Skips install steps if `.chatterbox_setup_done` exists.
- `ChatterboxToolkitUI.py` — Main Gradio application.

The `toolkit/` virtual environment and `nltk_data/` are created automatically and are listed in `.gitignore`.

## 📜 License

MIT (see [LICENSE](LICENSE)).
