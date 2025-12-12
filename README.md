# 🎮 Super Mario ASM

A fully functional **Super Mario-style platformer** developed entirely in **x86 Assembly Language** using MASM and Irvine32 library.

![Assembly](https://img.shields.io/badge/Language-x86%20Assembly-blue)
![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📖 Overview

This project is a complete Super Mario clone built from scratch using low-level x86 Assembly. It features multiple levels, enemies, power-ups, a shop system, and custom audio — all implemented without high-level libraries.

---

## ✨ Features

### 🔥 Cheat System with Dual Fireballs
- Type **"cheat"** as your name to activate cheat mode
- **Red Fireballs (R)**: Eliminate enemies on contact
- **Blue Fireballs (B)**: Collect distant coins and power-ups remotely

### 👹 Boss Fight with Particle Effects (Level 4)
- Epic boss battle with 6 health points
- Dynamic particle animations trigger at 2/3 and 1/3 health
- Earn 2000 bonus points for defeating the boss

### 🦘 Double Jump Mechanic
- Perform a second jump while mid-air
- Reach higher platforms and escape enemies more easily

### 🍄 Spring Mushroom Power-Up
- Temporarily increases jump height
- Access hard-to-reach areas and collect high coins

### 🛒 In-Game Shop System
- Press **P** to pause and access the shop
- Purchase items using collected tokens:
  - **1 Extra Life** — 8 Tokens
  - **2 Red Shots** — 13 Tokens (requires cheat mode)

### 🎵 Full Audio System
- Level-specific background music
- Sound effects for jumps, coins, win/lose states, and menu navigation

### 🏆 High Score System
- Persistent high score tracking
- Enter your name and compete for the top spot

---

## 🎮 Controls

| Key | Action |
|-----|--------|
| `W` / `↑` | Jump |
| `A` / `←` | Move Left |
| `D` / `→` | Move Right |
| `S` / `↓` | Move Down |
| `R` | Shoot Red Fireball (Cheat Mode) |
| `B` | Shoot Blue Fireball (Cheat Mode) |
| `P` | Pause Game / Open Shop |
| `ESC` | Back / Exit |

---

## 🗂️ Project Structure

```
Super-Mario-ASM/
├── Files/
│   ├── i240544_D_level-1.asm    # Level 1 - Main menu & first stage
│   ├── i240544_D_level-2.asm    # Level 2
│   ├── i240544_D_level-3.asm    # Level 3
│   ├── i240544_D_level-4.asm    # Level 4 - Boss Fight
│   ├── highscores.txt           # High score data
│   └── Sounds/                  # Audio files
│       ├── menu_bg.wav
│       ├── level-1_bg.wav
│       ├── level-2_bg.wav
│       ├── level-3_bg.wav
│       ├── level-4_bg.wav
│       ├── jump.wav
│       ├── Coin.wav
│       ├── winner.wav
│       ├── Losing.wav
│       └── ...
├── LICENSE
└── README.md
```

---

## 🛠️ Prerequisites

Before compiling, ensure you have the following installed:

1. **Microsoft Macro Assembler (MASM)** — Included with Visual Studio
2. **Irvine32 Library** — [Download from GitHub](https://github.com/meixinchoy/Irvine-library?tab=readme-ov-file)
3. **Visual Studio** (2019 or later recommended) with C++ Desktop Development workload

> 📚 **Reference Book:** [Assembly Language for x86 Processors by Kip Irvine](https://www.asmirvine.com/)

---

## ⚙️ How to Compile and Run

### Option 1: Using Visual Studio

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Raja-Sherhyar-Ameer/Super-Mario-ASM.git
   cd Super-Mario-ASM
   ```

2. **Open Visual Studio** and create a new **Empty Project** (or use an existing MASM project template).

3. **Configure the project for MASM:**
   - Right-click the project → **Build Dependencies** → **Build Customizations**
   - Check **masm(.targets, .props)**

4. **Add the ASM files:**
   - Right-click **Source Files** → **Add** → **Existing Item**
   - Select `i240544_D_level-1.asm` (this is the main entry point)

5. **Configure Irvine32:**
   - Go to **Project Properties** → **Linker** → **General**
   - Add the Irvine32 library path to **Additional Library Directories**
   - Go to **Linker** → **Input** and add `Irvine32.lib` to **Additional Dependencies**

6. **Build and Run:**
   - Press `Ctrl + Shift + B` to build
   - Press `Ctrl + F5` to run without debugging

### Option 2: Using Command Line (MASM)

1. **Open Developer Command Prompt for Visual Studio**

2. **Navigate to the project directory:**
   ```cmd
   cd path\to\Super-Mario-ASM\Files
   ```

3. **Assemble the code:**
   ```cmd
   ml /c /coff /Zi i240544_D_level-1.asm
   ```

4. **Link the object file:**
   ```cmd
   link /SUBSYSTEM:CONSOLE /DEBUG i240544_D_level-1.obj Irvine32.lib kernel32.lib user32.lib winmm.lib
   ```

5. **Run the executable:**
   ```cmd
   i240544_D_level-1.exe
   ```

> ⚠️ **Note:** Make sure the `Sounds` folder is in the same directory as the executable for audio to work properly.

---

## 📸 Screenshots

*Coming soon...*

---

## 🎓 Academic Project

This project was developed as part of an academic assignment to demonstrate low-level programming concepts including:

- Memory management
- Hardware-level graphics rendering
- Game loop implementation
- Collision detection algorithms
- Audio system integration using Windows MCI

---

## 👨‍💻 Author

**Raja Sherhyar Ameer**

- GitHub: [@Raja-Sherhyar-Ameer](https://github.com/Raja-Sherhyar-Ameer)
- Roll Number: 24I-0544

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- [Kip Irvine](https://www.asmirvine.com/) — Author of "Assembly Language for x86 Processors"
- [Irvine32 Library](https://github.com/meixinchoy/Irvine-library?tab=readme-ov-file) — Assembly library for Windows
- Nintendo — Original Super Mario inspiration

---

⭐ **If you found this project interesting, please consider giving it a star!**
