# Project SoliU

<a href="https://apps.apple.com/us/app/soliu/id6535658392">
  <img src="Pic/soliu_logo.png" width="15%" alt="SoliU Logo"/>
</a>


| Main |
| ----- |
| ![Build Status](https://github.com/SoliUTeam/MentalHealth/actions/workflows/build.yml/badge.svg?branch=main) |


A calming, personalized mental health app designed to help users of all ages manage stress and emotional well-being.


# 🔧 Firebase Analytics Debug Mode

Firebase's **DebugView** allows you to monitor Analytics events in **real-time** during development.  
You can enable debug mode on your iOS simulator or test device using the command below.

---

## 🚀 How to Enable Debug Mode

Run the following command in your terminal while the simulator is running:

```bash
xcrun simctl spawn booted defaults write com.google.firebase.analytics debug-mode 1
