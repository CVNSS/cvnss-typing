# ⭐ cvnss-typing 2020
**CVNSS4.0 Real-time Typing Engine (Windows Tray IME-like Tool)**

**cvnss-typing** is an open-source, IME-like tray tool for Windows that converts **CVNSS4.0 (Chữ Việt Nam Song Song 4.0)** input into properly accented Vietnamese text in real time.

> **License:** MIT  
> **Cha Đẻ (Founders):** Trần Tư Bình, Kiều Trường Lâm  
> **Archive:** https://chuvietnhanh.sourceforge.net/  
> **Official project site:** https://chuvnsongsong.com/  by hoaflee
> **Attribution:** Hoàng Văn Bát, Trần Thị Minh, Nguyễn Thị Thái, Nguyễn Văn Luận, Phạm Hợi, ...  
> **Implementation Author:** Long Ngo

---

## 🌐 Multilingual Overview

### 🇬🇧 English
**cvnss-typing** provides a lightweight Windows tray experience similar to an IME. It supports typing with **CVNSS4.0**, a parallel Vietnamese writing system designed to optimize typing efficiency and maintain phonetic clarity. The tool converts CVNSS-style tokens into standard Vietnamese orthography instantly (e.g., when pressing Space/Enter/Tab/punctuation) and can display short inline candidate suggestions near the caret.

### 🇻🇳 Tiếng Việt
**cvnss-typing** là công cụ bộ gõ dạng IME chạy nền trên Windows. Bạn gõ theo **CVNSS4.0 (Chữ Việt Nam Song Song 4.0)** và hệ thống sẽ tự chuyển sang chữ Quốc Ngữ có dấu theo thời gian thực khi bấm **Space/Enter/Tab/dấu câu**, đồng thời có thanh gợi ý 4–6 từ gần vị trí con trỏ (tùy chế độ).

### 🇨🇳 中文（简体）
**cvnss-typing** 是一个轻量级的 Windows 托盘工具，体验类似输入法（IME）。它支持使用 **CVNSS4.0 越南语并行文字系统**进行输入，并在按下空格/回车/Tab/标点时实时转换为标准越南语拼写，同时可在光标附近显示 4–6 个候选建议（视模式而定）。

### 🇷🇺 Русский
**cvnss-typing** — это лёгкий инструмент для Windows в стиле IME (значок в трее). Он позволяет вводить текст с использованием параллельной вьетнамской письменности **CVNSS4.0** и мгновенно преобразовывать ввод в стандартный вьетнамский текст при нажатии пробела/Enter/Tab/знаков пунктуации. Также доступны подсказки (4–6 вариантов) возле курсора (в зависимости от режима).

### 🇯🇵 日本語
**cvnss-typing** は Windows のトレイで動作する軽量な IME 風ツールです。**CVNSS4.0（ベトナム語の並列文字体系）**で入力し、スペース/Enter/Tab/句読点のタイミングで標準的なベトナム語表記へリアルタイム変換します。カーソル付近に 4〜6 件の候補を表示する機能もあります（モードによる）。

### 🇰🇷 한국어
**cvnss-typing**은 Windows 트레이에서 실행되는 경량 IME형 도구입니다. **CVNSS4.0 베트남어 병렬 문자 체계**로 입력한 내용을 공백/Enter/Tab/문장부호 입력 시점에 표준 베트남어 표기로 실시간 변환합니다. 또한 커서 근처에 4–6개의 후보 추천을 표시할 수 있습니다(모드에 따라 다름).

### 🇰🇭 ភាសាខ្មែរ (Khmer)
**cvnss-typing** គឺជាកម្មវិធីបែប IME សម្រាប់ Windows ដែលរត់នៅលើ Tray។ វាអនុញ្ញាតឱ្យវាយតាមប្រព័ន្ធអក្សរ **CVNSS4.0** ហើយបម្លែងទៅជាអក្សរវៀតណាមស្តង់ដារដោយស្វ័យប្រវត្តិ នៅពេលចុច Space/Enter/Tab/សញ្ញាវ្យាករណ៍។ ក៏អាចបង្ហាញការណែនាំ (4–6 ជម្រើស) ជិតទីតាំង cursor ផងដែរ (អាស្រ័យលើ mode)។

---

## ✨ Key Features

- ⭐ **Tray-based IME-like workflow** (toggle on/off)
- ⚡ **Real-time conversion** on: Space / Enter / Tab / punctuation
- 🧠 **Inline suggestions** (4–6 candidates near caret) — accept via **Tab** or **1..6**, **Esc** to hide
- 📝 **Notepad-first optimization** (fast and stable in Notepad)
- 📦 **Portable build** — EXE can run on a target PC **without installing AutoHotkey**
- 🔓 **Open-source (MIT)**

---

## ✅ Example

Type:

```txt
Chuc mugk namo moix
```

Press **Space** →

```txt
Chúc mừng năm mới
```

---

## 🚀 Quick Start

### Requirements
- Windows 10/11
- AutoHotkey v2 (for running from source)
- Node.js (for converter + suggestion engine in `tools/`)

### Run from source
```bat
scripts\RUN.cmd
```

### Toggle
- **Ctrl + Alt + V**

---

## 🧱 Build Portable EXE

```bat
scripts\BUILD_EXE.cmd
```

Output:
- `dist\CVNSS-IME.exe`

> This EXE runs on other PCs **without installing AutoHotkey**.

---

## 🎒 Create Full Portable Package (Optional)

```bat
scripts\PACK_PORTABLE.cmd
```

Output folder:
- `dist\CVNSS-IME-PORTABLE\`

Run on any PC:
- `Start.cmd`

> If `node\node.exe` exists inside the portable folder, the target PC does **not** need Node.js installed.

---

## 📁 Project Structure

```txt
assets/        # icons / branding
ime/           # AutoHotkey v2 IME-like tray script
tools/         # Node.js converter + suggestion CLIs
scripts/       # run / build / packaging scripts
docs/          # notes and quick tests
```

---

## 📌 About CVNSS4.0 (Official References)

- Official project site: https://chuvnsongsong.com/  
- Archive repository: https://chuvietnhanh.sourceforge.net/  
- Formula / Rules: https://chuvietnhanh.sourceforge.net/TomGonCongThucCVNSS.htm  
- Research paper: https://vietnamhoc.net/chu-vn-song-song-cvnss4-0-trong-boi-canh-cach-mang-cong-nghe-4-0/

---

## 👥 Credits

- **Cha Đẻ (Founders):** Trần Tư Bình, Kiều Trường Lâm  
- **Implementation Author (this tool):** Long Ngo  
- **Copyright ID:** 1850/2020/QTG  

---

## 🪪 License
MIT License — see [`LICENSE`](LICENSE).

---

## 🧾 Update & Push (local)

```bat
git add README.md
git commit -m "docs: update README (multilingual + official references)"
git push
```
