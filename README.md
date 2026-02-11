# cvnss-typing

**cvnss-typing** is an open-source, IME-like tray tool for Windows that converts **CVNSS4.0 / CVN / CVSS typing** into properly accented Vietnamese in real time.

- **Author:** Long Ngo  
- **Credits:** Trần Tư Bình, Kiều Trường Lâm  
- **Copyright ID:** 1850/2020/QTG  
- **License:** MIT  

> Prototype implementation: **AutoHotkey v2 + Node.js** (converter/suggester CLI).

---

## Key features

- **IME-like tray app** (toggle on/off) with a simple **gold star** icon.
- **Notepad-first mode**: token replacement is done directly in Notepad (Edit1) without clipboard tricks.
- Convert on delimiters: **Space / Enter / Tab / punctuation**.
- **Inline suggestions**: shows **4–6 candidates** near the caret; **Tab** or **1..6** to accept; **Esc** to hide.
- **Portable output**:
  - Build a standalone `CVNSS-IME.exe` (**target PC does NOT need AutoHotkey installed**).
  - Optional portable pack can bundle `node.exe` too (so the target PC does not need Node.js installed).

---

## Quick start (run from source)

### Requirements
- Windows 10/11
- **AutoHotkey v2**
- **Node.js** (for `tools\convert_cli.js` and `tools\suggest_cli.js`)

### Run
```bat
scripts\RUN.cmd
```

### Toggle
- **Ctrl + Alt + V** → ON/OFF

### Test (Notepad)
1. Open Notepad
2. Type: `Chuc mugk namo moix`
3. Press **Space**
4. Expected: `Chúc mừng năm mới`

---

## Build EXE (portable, no AutoHotkey required on target PC)

```bat
scripts\BUILD_EXE.cmd
```

Output:
- `dist\CVNSS-IME.exe`

---

## Create full portable folder (optional: bundle Node)

```bat
scripts\PACK_PORTABLE.cmd
```

Output:
- `dist\CVNSS-IME-PORTABLE\`

Run on any PC:
- `dist\CVNSS-IME-PORTABLE\Start.cmd`

> If `node\node.exe` exists inside the portable folder, the target PC does **not** need Node.js installed.

---

## Project layout

```
assets\               # icon (cvnss_star.ico)
ime\CVNSS-IME.ahk      # AutoHotkey v2 tray app
tools\                 # Node.js CLIs + converter core
scripts\               # run/build/pack + publish helpers
docs\                  # quick test notes
```

---

## Converter & suggestions

The IME calls Node.js CLIs:
- `tools\convert_cli.js` → converts a token to Vietnamese
- `tools\suggest_cli.js` → returns top candidates for the current token

The conversion core lives in:
- `tools\cvnss4.0-converter.js`

You can replace or upgrade the converter implementation without changing the IME UX.

---

## Troubleshooting

### I see `báº£ng` instead of `bảng`
This is a **mojibake encoding issue** (UTF-8 decoded as ANSI).  
This repo includes a built-in auto-fix that repairs common mojibake sequences before inserting text.

If you still see mojibake:
- Ensure Notepad file is UTF-8
- Ensure you are using the latest script in `ime\CVNSS-IME.ahk`

---

## Security note

This tool sends the current token to a local Node.js process for conversion/suggestions.  
No network calls are required by default.

---

## License

MIT — see [LICENSE](LICENSE).
