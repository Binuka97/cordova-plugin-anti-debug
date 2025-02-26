# 📌 **Cordova Plugin: Anti-Debug & Developer Options Detection**  
**Version:** 1.0.0  

🚀 A Cordova plugin that **detects and prevents debuggers**, checks if the device has **Developer Options enabled**, and implements **anti-debugging techniques** for **Android & iOS**.

## 📜 **Features**
✅ **Detect if a debugger is attached (Android & iOS)**  
✅ **Prevent debugger from attaching (Android & iOS)**  
✅ **Check if Developer Options are enabled (Android & iOS)**  
✅ **Uses TracerPid check for stronger security (Android)**  
✅ **Lightweight and optimized for security**  

---

## 📥 **Installation**
You can install the plugin using the Cordova CLI:

```sh
cordova plugin add https://github.com/your-repo/cordova-plugin-antidebug.git
```

To remove the plugin:

```sh
cordova plugin remove cordova-plugin-antidebug
```

---

## 🚀 **Usage**
This plugin exposes two methods:

1️⃣ **Detect if a debugger is attached**
```javascript
cordova.plugins.AntiDebug.isDebugged(
    function(result) {
        if (result) {
            console.log("Debugger detected! Taking action...");
        } else {
            console.log("No debugger detected.");
        }
    },
    function(error) {
        console.error("Error detecting debugger:", error);
    }
);
```

2️⃣ **Check if Developer Options are enabled**
```javascript
cordova.plugins.AntiDebug.isDevOptionsEnabled(
    function(result) {
        if (result) {
            console.warn("Developer Options are enabled! This may indicate a security risk.");
        } else {
            console.log("Developer Options are disabled.");
        }
    },
    function(error) {
        console.error("Error checking Developer Options:", error);
    }
);
```

---

## 📱 **Supported Platforms**
- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12+)

---

## 🔧 **How It Works**
- Uses **`Debug.isDebuggerConnected()`** & **`TracerPid`** on Android to detect debugging.
- Uses **`sysctl`** on iOS to check if the app is being traced.
- Uses **`ptrace`** to prevent the debugger from attaching.
- Detects **Developer Options** using system settings.

---

## 🛠️ **Troubleshooting**
- If the plugin is not recognized, make sure to remove and reinstall the plugin:
  ```sh
  cordova plugin remove cordova-plugin-antidebug
  cordova plugin add https://github.com/your-repo/cordova-plugin-antidebug.git
  ```
- Ensure that you have the correct **Android & iOS permissions** set up in your project.

---

## 👨‍💻 **Contributing**
Feel free to contribute by submitting a pull request or reporting issues in the repository.

---

## 📄 **License**
This project is licensed under the **MIT License**.  

---

### **🚀 Ready to Secure Your Cordova App?**
🔹 **Install the plugin**  
🔹 **Protect your app from debugging & Developer Options**  
🔹 **Improve security with anti-debugging techniques**  

🚀 **Happy Coding!** 🎯
