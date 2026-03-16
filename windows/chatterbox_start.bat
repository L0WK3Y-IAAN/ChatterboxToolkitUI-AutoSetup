@echo off
setlocal

:: Script directory (no trailing backslash) for PATH
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

:: Repo root is the parent of this windows folder
for %%I in ("%SCRIPT_DIR%\..") do set "ROOT_DIR=%%~fI"

:: Add script directory to User PATH if not already present (run from anywhere in new terminals)
powershell -NoProfile -Command ^
  "& { param($d) ^
       $p = [Environment]::GetEnvironmentVariable('Path','User'); ^
       if (-not $p) { $p = '' } ^
       if ($p -notlike ('*' + $d + '*')) { ^
         [Environment]::SetEnvironmentVariable('Path', ($p.TrimEnd(';') + ';' + $d), 'User'); ^
         Write-Host '[+] Added ChatterboxToolkitUI launcher directory to PATH.' ^
       } ^
     }" -ArgumentList "%SCRIPT_DIR%"

:: Ensure this session sees the directory too
set "PATH=%SCRIPT_DIR%;%PATH%"

:: Always work from the repo root so toolkit/ and setup.py are found there
cd /d "%ROOT_DIR%"

echo ==========================================
echo     Chatterbox Toolkit UI Launcher
echo ==========================================

:: Check if the virtual environment exists in the repo root
if not exist "%ROOT_DIR%\toolkit\Scripts\python.exe" (
    echo [*] Virtual environment not found. Creating 'toolkit'...
    python -m venv "%ROOT_DIR%\toolkit"
    echo [+] Virtual environment created successfully.
) else (
    echo [*] Virtual environment 'toolkit' already exists.
)

:: Activate the virtual environment
echo [*] Activating virtual environment...
call "%ROOT_DIR%\toolkit\Scripts\activate.bat"

:: Run the setup script (which will install dependencies and launch the UI)
echo [*] Running setup.py from %ROOT_DIR%...
python "%ROOT_DIR%\setup.py"

:: Deactivate when done
deactivate
pause

