@echo off
setlocal

:: Script directory (no trailing backslash) for PATH
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

:: Add script directory to User PATH if not already present (run from anywhere in new terminals)
powershell -NoProfile -Command "& { param($d); $p = [Environment]::GetEnvironmentVariable('Path', 'User'); if ($p -and $p -notlike ('*' + $d + '*')) { [Environment]::SetEnvironmentVariable('Path', $p.TrimEnd(';') + ';' + $d, 'User'); Write-Host '[+] Added script directory to PATH. You can run chatterbox_start.bat from anywhere in new terminals.' } }" -ArgumentList "%SCRIPT_DIR%"
set "PATH=%SCRIPT_DIR%;%PATH%"

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
