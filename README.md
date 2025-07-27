# Mental Health Project 

<a href="https://apps.apple.com/us/app/soliu/id6535658392">
  <img src="Pic/soliu_logo.png" width="15%" alt="SoliU Logo"/>
</a>

A calming, personalized mental health app designed to help users of all ages manage stress and emotional well-being.

# Installation Guide

# 🚀 Installation & Packaging Guide (Xcode 16.3)

## ✅ Prerequisites

- macOS 13 or later  
- Xcode 16.3 installed ([Download here](https://developer.apple.com/xcode/))  
- A valid Apple Developer account (free or paid)

---

## 🛠️ Running the App Locally

### 1. Clone the repository

- Open Terminal.
- Run the following command:

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo
```

# 🔧 Firebase Analytics Debug Mode

Firebase's **DebugView** allows you to monitor Analytics events in **real-time** during development.  
You can enable debug mode on your iOS simulator or test device using the command below.

---

## 🚀 How to Enable Debug Mode

Run the following command in your terminal while the simulator is running:

```bash
xcrun simctl spawn booted defaults write com.google.firebase.analytics debug-mode 1
