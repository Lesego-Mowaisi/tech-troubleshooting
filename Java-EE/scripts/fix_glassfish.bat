@echo off

:: Auto-elevate to admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting admin privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

echo Killing processes on port 8080...
FOR /F "tokens=5" %%P IN ('netstat -ano ^| findstr :8080') DO taskkill /PID %%P /F
echo Done. You can now start GlassFish.
pause
