# CVNSS4.0 (Typing) - Quick test (Notepad-first)

Run:
- scripts\RUN.cmd

Toggle:
- Ctrl + Alt + V

Test:
- Open Notepad
- Type: Chuc mugk namo moix
- Press Space
=> Chúc mừng năm mới

Suggestions:
- Shows 4-6 candidates above caret in Notepad
- Tab accepts #1, or press 1..6
- Esc hides

Build EXE:
- scripts\BUILD_EXE.cmd
- dist\CVNSS-IME.exe


Portable pack:
- scripts\PACK_PORTABLE.cmd
- Output: dist\CVNSS-IME-PORTABLE\ (contains CVNSS-IME.exe + tools + optional node.exe)


UTF-8 note:
- If you see mojibake like `báº£ng` instead of `bảng`, update to the latest script: it auto-repairs common mojibake before inserting text.
