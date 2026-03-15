@echo off
setlocal

cd /d "%~dp0"

echo ==========================================
echo     Chatterbox Toolkit UI Launcher
echo ==========================================

:: Check if the virtual environment exists
if not exist "toolkit\Scripts\python.exe" (
    echo [*] Virtual environment not found. Creating 'toolkit'...
    python -m venv toolkit
    echo [+] Virtual environment created successfully.
) else (
    echo [*] Virtual environment 'toolkit' already exists.
)

:: Activate the virtual environment
echo [*] Activating virtual environment...
call toolkit\Scripts\activate.bat

:: Run the setup script (which will install dependencies and launch the UI)
echo [*] Running setup.py...
python setup.py

:: Deactivate when done
deactivate
pause
