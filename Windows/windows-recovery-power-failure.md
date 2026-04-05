# Windows Installation Recovery: Power Failure During Reset

**Document Type:** Troubleshooting Report  
**Date:** 04 April 2026  
**Author:** Lesego Mowaisi 
**Environment:** Windows 10/11 — Personal Laptop

---

## 🚩 Problem Statement
While performing a factory reset on a personal machine, the power cable was disconnected mid-process. The battery died during the Windows installation phase, causing an unexpected shutdown.

Upon restarting, the system entered a **boot loop** displaying the following error:

> "The computer restarted unexpectedly or encountered an unexpected error. Windows installation cannot proceed."

Clicking **OK** restarted the machine and reproduced the same error, making normal recovery impossible.

---

## 🔍 Root Cause
An interrupted power supply during OS installation corrupted the **Windows Setup State**. The setup process recorded an incomplete status, causing it to loop on restart rather than proceed to the next installation phase.

---

## 🛠️ Resolution

### Prerequisites
* Access to the affected machine.
* Power cable connected and stable.

### Steps
1. On the error screen, press `Shift + F10` to open **Command Prompt**.
2. Type `regedit` and press **Enter** to open the **Registry Editor**.
3. Navigate to the following path:  
   `HKEY_LOCAL_MACHINE\SYSTEM\Setup\Status\ChildCompletion`
4. Locate the `setup.exe` entry and double-click it.
5. Change the **Value Data** from `1` to `3`.
6. Close the Registry Editor and click **OK** on the error screen.
7. The installation will bypass the error and complete successfully.

> ⚠️ **Warning:** Incorrect registry edits can cause further system instability. Follow the steps exactly as documented.

---

## 💡 Explanation
Setting the `setup.exe` value to `3` manually signals to Windows that the setup process is **complete**. This allows the system to advance past the blocked phase and continue the boot sequence normally.

## 🛡️ Prevention
**Always ensure a stable AC power source** is connected before initiating critical OS operations such as factory resets, Windows updates, or installation procedures. Do not rely on battery power alone for these processes.

---

## 📝 Author's Personal Note
I encountered this error during a personal PC reset when my battery died. While I found the specific Registry fix through research, I am documenting it here to better understand how the Windows "Setup State" works.

**What I learned from this:**
- Technical "loops" are often controlled by status codes in the Registry that can be manually overridden.
- Power stability is critical during OS installation to prevent data and state corruption.
- I am currently researching why the value `3` specifically signals a "Complete" state in the `ChildCompletion` key to deepen my understanding of Windows deployment.
