![Glance Banner](https://raw.githubusercontent.com/LukeMutlow-21/Glance/main/Glance/Assets.xcassets/Glance_1758x400.png)

# Glance

> **Everything you need, at a glance.**

![macOS](https://img.shields.io/badge/macOS-13%2B-green)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![Signed](https://img.shields.io/badge/signed-no-red)

---

## Overview

Glance gives Mac users instant visibility into their system's health by surfacing key performance metrics directly in the menu bar. Users can configure warning thresholds and refresh rates in the app's settings to monitor specific metrics, such as CPU usage, RAM consumption, and battery status.

---

## Features

- ⚡ **Instant visibility** — CPU, RAM, GPU, Storage, Network and Battery at a glance  
- 🎯 **Colour-coded thresholds** — Green, amber and red ranges make issues obvious immediately  
- 🔔 **Critical notifications** — Get alerted when CPU or RAM hits critical levels  
- ⚙️ **Customisable** — Set your own warning thresholds and refresh rate  
- 🚀 **Launch at login** — Always there when you need it  
- 🪶 **Lightweight** — No Dock icon, minimal overhead, fast startup  

---

## Requirements

- macOS 13 (Ventura) or later  
- Xcode 15+ (to build from source)

---

## Installation

Head to [Releases](https://github.com/LukeMutlow-21/Glance/releases) and download the latest version.

> ⚠️ **Unsigned App — Important**
>
> Glance is currently unsigned, meaning it has not been notarised by Apple.  
> macOS Gatekeeper will block it from opening normally on first launch.
>
> **To open it for the first time:**
> 1. Unzip and drag `Glance.app` to your `/Applications` folder  
> 2. **Right-click** `Glance.app` → **Open**  
> 3. Click **Open** again in the Gatekeeper dialog
>
> You only need to do this once. After that it will open normally.

---

## Building from Source

```bash
git clone https://github.com/LukeMutlow-21/Glance.git
cd Glance
open Glance.xcodeproj
