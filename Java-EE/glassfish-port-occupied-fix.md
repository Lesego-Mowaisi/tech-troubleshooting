# GlassFish Server: HTTP/HTTPS Listener Port Occupied
**Document Type:** Troubleshooting Report  
**Date:** 08 April 2026  
**Author:** Lesego Mowaisi  
**Environment:** Apache NetBeans IDE 21, GlassFish Server 7

---

## 🚩 Problem Statement

When attempting to start **GlassFish Server** from within NetBeans IDE, the following error appeared:

> "Could not start GlassFish Server (1): HTTP or HTTPS listener port is occupied while server is not running."

The server repeatedly failed to start despite not appearing to be running. This error occurred consistently across multiple development sessions.

---

## 🔍 Root Cause

A previous GlassFish instance had **crashed or was closed without being properly stopped**, leaving a background Java process still occupying **port 8080**. Windows did not release the port automatically, causing every new GlassFish startup attempt to fail.

---

## 🛠️ Resolution

### Prerequisites
- Access to the affected Windows machine.
- Administrator privileges.

### Steps

1. Create a batch script file named `fix_glassfish.bat` with the following content:

```bat
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
```

2. **Right-click** the script and select **"Run as administrator"** — or the script will request elevation automatically.
3. Wait for the confirmation message: `Done. You can now start GlassFish.`
4. Return to NetBeans and start GlassFish normally.

> ⚠️ **Warning:** This script force-kills any process on port 8080. Ensure no other critical application is using that port before running it.

---

## 💡 Explanation

The script works by:
- Using `netstat -ano` to list all active network connections with their Process IDs (PIDs).
- Using `findstr :8080` to filter only processes occupying port 8080.
- Extracting the PID from column 5 of the output (`tokens=5`).
- Running `taskkill /F` to **force-terminate** that process.
- The admin elevation block ensures Windows grants the necessary permissions to kill system-level processes.

---

## 🛡️ Prevention

Always **stop GlassFish properly** before closing NetBeans:
> NetBeans → Services tab → Right-click GlassFish → **Stop**

This prevents zombie processes from holding the port open across sessions.

---

## 📝 Author's Personal Note

This was a recurring issue during my Java EE development sessions — every time NetBeans closed unexpectedly, I had to manually hunt down the process ID and kill it through Command Prompt. I eventually automated the fix with a batch script.

**What I learned from this:**

- Network ports are not always released automatically when a process crashes — the OS holds them until the process is explicitly terminated.
- Batch scripting can automate repetitive terminal tasks, following the same **DRY (Don't Repeat Yourself)** principle used in programming.
- Windows requires **administrator privileges** to terminate system-level processes, which can be handled programmatically using PowerShell elevation inside the script.
- I am continuing to explore how `netstat` and process management work at the OS level to deepen my understanding of network and system administration.

> 🖊️ *Side note: This was my first ever script. What started as a frustrating daily problem turned into my introduction to automation.*
