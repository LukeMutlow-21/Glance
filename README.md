![Glance Banner](https://raw.githubusercontent.com/LukeMutlow-21/Glance/main/Glance/Assets.xcassets/Glance_1758x400.png)

# Glance

> **Everything you need, at a glance.**

![macOS](https://img.shields.io/badge/macOS-13%2B-green)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![Notarised](https://img.shields.io/badge/notarised-no-red)

---

## Overview

Glance is a lightweight macOS menu bar app that provides instant visibility into your system’s health. Key performance metrics are displayed directly in the menu bar, allowing you to spot issues at a glance without opening heavy system tools.

Users can configure warning thresholds and refresh rates to monitor the metrics that matter most to them, including CPU usage, memory pressure, battery status, and more.

---

## Features

- ⚡ **Instant visibility** — CPU, RAM, GPU, Storage, Network, and Battery at a glance  
- 🎯 **Colour‑coded thresholds** — Green, amber, and red ranges make issues obvious immediately  
- 🔔 **Critical notifications** — Optional alerts when CPU or RAM usage reaches critical levels  
- ⚙️ **Customisable** — Set your own refresh rate and warning thresholds  
- 🚀 **Launch at login** — Always available when you need it

---

## Requirements

- macOS 13 (Ventura) or later  
- Xcode 15 or later (to build from source)

---

## Installation

Download the latest **`Glance.zip`** from the [Releases](https://github.com/LukeMutlow-21/Glance/releases) page.

1. Unzip the downloaded file  
2. Drag **`Glance.app`** into your **Applications** folder  

---

## Building from Source

When building from source in Xcode, you must enable outgoing network connections for the Ping feature to work:

1. Open the project in Xcode
2. Go to **Targets → Glance → Signing & Capabilities**
3. Under **App Sandbox → Network**, tick **Outgoing Connections (Client)**

Without this, the Ping monitor will show "Timeout".

---

## ⚠️ Unsigned App — Important

Glance is currently **unsigned and not notarised by Apple**. Because of this, macOS Gatekeeper will block the app the first time you try to open it.

To run Glance for the first time:

1. Open **System Settings → Privacy & Security**  
2. Scroll down to the Security section  
3. Click **Open Anyway** next to Glance  
4. Confirm when prompted  

This is only required once. After approval, Glance will open normally.

---

© 2026 Luke Mutlow. All rights reserved.
