# 🗣️ ChatterboxToolkit-AutoSetup

A streamlined, fully automated deployment wrapper and Web GUI for [Resemble AI's Chatterbox](https://github.com/resemble-ai/chatterbox) Text-to-Speech model. 

Getting heavy local LLM/TTS models running can be a headache of dependency conflicts and virtual environment management. **ChatterboxToolkit-AutoSetup** solves this by providing one-click launch scripts that handle everything from environment creation and dependency resolution to automatically launching the Gradio UI in your browser.

## ✨ Key Features

- **🚀 True One-Click Setup:** Run `start.sh` or `start.bat`. The script automatically creates an isolated `toolkit` virtual environment, installs PyTorch/Gradio, downloads NLTK data, and boots the app.
- **🍎 Apple Silicon Native:** Automatically routes hardware acceleration to use Apple's Metal Performance Shaders (`mps`) on macOS, bypassing the massive slowdowns caused by running models in CPU-only Docker containers.
- **🌐 Auto-Browser Launch:** The moment the TTS pipeline is fully loaded into memory, your default web browser will automatically open the Gradio interface.
- **🎙️ Full UI Capabilities:** Easy-to-use Gradio interface for text-to-speech generation, voice cloning embeddings, and emotional exaggeration tuning.

## 🛠️ Prerequisites

Before you run the auto-setup, ensure your system has the following:
- **Python 3.10 or 3.11** 
- **FFmpeg** (Required by PyDub/Audio processing)
  - macOS: `brew install ffmpeg`
  - Linux: `sudo apt install ffmpeg`
  - Windows: `winget install ffmpeg`

## 🚀 Quick Start (Auto-Setup)

Drop these files into your directory and run the launcher for your OS. The script handles the rest.

### macOS / Linux
Open your terminal, navigate to the folder, and run:
```bash
chmod +x start.sh
./start.sh
