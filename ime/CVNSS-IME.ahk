/* ============================================================
   CVNSS4.0 (Typing) — IME-like Tray Tool (AutoHotkey v2)
   About:
     CVNSS4.0 (Typing)
     Tac gia: Long Ngo
     Nam: @2020
     Ghi cong: Tran Tu Binh, Kieu Truong Lam
     Ban Quyen: 1850/2020/QTG

   Hotkey:
     Ctrl + Alt + V  : Toggle ON/OFF

   Behavior:
     - Notepad-first (Edit1): replace token directly (no clipboard hack)
     - When ON: type "Chuc mugk namo moix" then press Space => "Chúc mừng năm mới"
     - Suggestions 4–6 items above caret (Notepad-first):
         Tab or 1..6 to accept, Esc to hide

   Requirements (prototype):
     - Node.js to run tools\convert_cli.js and tools\suggest_cli.js
     - For portable pack: include node\node.exe next to the exe

   ============================================================ */

#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook True

; ----------------------------
; Globals (MUST be before final Return of auto-exec)
; ----------------------------
global gEnabled := false
global gMode := "cvn"                     ; cvn / cvss
global gNotepadOnly := true

global gNode := "node"
global gConvertCli := ""
global gSuggestCli := ""

global gIcon := ResolvePath([
    A_ScriptDir "\..\assets\cvnss_star.ico",
    A_ScriptDir "\assets\cvnss_star.ico"
], "")

global gSugVisible := false
global gSug := []                         ; Array<String>
global gLastToken := ""
global gLastCaret := -1

global gSugGui := 0
global gSugTextCtl := 0

; ----------------------------
; Init paths (dev vs portable)
; ----------------------------
InitRuntime()

; ----------------------------
; Tray
; ----------------------------
if (gIcon != "")
    TraySetIcon(gIcon)

A_TrayMenu.Delete()
A_TrayMenu.Add("Toggle (Ctrl+Alt+V)", (*) => Toggle())
A_TrayMenu.Add("Mode: CVN",  (*) => SetMode("cvn"))
A_TrayMenu.Add("Mode: CVSS", (*) => SetMode("cvss"))
A_TrayMenu.Add()
A_TrayMenu.Add("Suggestion: Notepad only", (*) => ToggleNotepadOnly())
A_TrayMenu.Check("Suggestion: Notepad only")
A_TrayMenu.Add("Test: Open Notepad", (*) => Run("notepad.exe"))
A_TrayMenu.Add()
A_TrayMenu.Add("About", (*) => ShowAbout())
A_TrayMenu.Add("Exit", (*) => ExitApp())

; ----------------------------
; Hotkeys
; ----------------------------
^!v::Toggle()

; Delimiters
$Space::OnDelimiter("{Space}")
$Enter::OnDelimiter("{Enter}")
$Tab::OnDelimiter("{Tab}")
$.::OnDelimiter(".")
$,::OnDelimiter(",")
$SC027::OnDelimiter(";")          ; ;
$+SC027::OnDelimiter(":")         ; Shift+;
$SC01B::OnDelimiter("]")          ; ]
$+SC01B::OnDelimiter("}")         ; Shift+]
$SC028::OnDelimiter("'")          ; '
$+SC028::OnDelimiter('"')         ; Shift+' => "

; Suggestion accept (active only when popup visible)
#HotIf gSugVisible
Tab::AcceptSug(1)
1::AcceptSug(1)
2::AcceptSug(2)
3::AcceptSug(3)
4::AcceptSug(4)
5::AcceptSug(5)
6::AcceptSug(6)
Esc::HideSug()
#HotIf

SetTimer(UpdateSuggest, 120)

return  ; -------------------- end auto-exec --------------------

; ============================================================
; Init / Resolve helpers
; ============================================================

ResolvePath(candidates, fallback := "") {
    for _, p in candidates {
        if (p != "" && FileExist(p))
            return p
    }
    return fallback
}

InitRuntime() {
    global gNode, gConvertCli, gSuggestCli

    ; Prefer bundled node.exe in portable pack
    node1 := ResolvePath([
        A_ScriptDir "\node\node.exe",
        A_ScriptDir "\..\node\node.exe"
    ], "")

    if (node1 != "")
        gNode := node1
    else
        gNode := "node"

    ; Tools: dev layout (..\tools) OR portable layout (\tools)
    gConvertCli := ResolvePath([
        A_ScriptDir "\..\tools\convert_cli.js",
        A_ScriptDir "\tools\convert_cli.js"
    ], "")

    gSuggestCli := ResolvePath([
        A_ScriptDir "\..\tools\suggest_cli.js",
        A_ScriptDir "\tools\suggest_cli.js"
    ], "")
}

; ============================================================
; Toggle / mode / about
; ============================================================

Toggle() {
    global gEnabled
    gEnabled := !gEnabled
    TrayTip("CVNSS4.0 (Typing)", "Status: " (gEnabled ? "ON" : "OFF"))
    if (!gEnabled)
        HideSug()
}

SetMode(m) {
    global gMode
    gMode := m
    TrayTip("CVNSS4.0 (Typing)", "Mode = " StrUpper(m))
}

ToggleNotepadOnly() {
    global gNotepadOnly
    gNotepadOnly := !gNotepadOnly
    if (gNotepadOnly)
        A_TrayMenu.Check("Suggestion: Notepad only")
    else
        A_TrayMenu.Uncheck("Suggestion: Notepad only")
}

ShowAbout() {
    MsgBox(
        "CVNSS4.0 (Typing)`n"
        "Tac gia: Long Ngo`n"
        "Nam: @2020`n"
        "Ghi cong: Tran Tu Binh, Kieu Truong Lam`n"
        "Ban Quyen: 1850/2020/QTG",
        "About",
        "Iconi"
    )
}

; ============================================================
; Delimiter handler
; ============================================================

OnDelimiter(sendKey) {
    global gEnabled

    if (!gEnabled) {
        Send(sendKey)
        return
    }

    if (IsNotepadReady()) {
        ConvertCurrentToken_Notepad()
        Send(sendKey)
        return
    }

    ConvertPreviousToken_Clipboard()
    Send(sendKey)
}

; ============================================================
; Notepad-first helpers
; ============================================================

IsNotepadReady() {
    try {
        return (WinGetClass("A") = "Notepad" && ControlGetFocus("A") = "Edit1")
    } catch {
        return false
    }
}

Notepad_GetEditHwnd() {
    return ControlGetHwnd("Edit1", "A")
}

Notepad_GetSel(&s, &e) {
    h := Notepad_GetEditHwnd()
    bs := Buffer(4, 0), be := Buffer(4, 0)
    DllCall("SendMessageW", "Ptr", h, "UInt", 0x00B0, "Ptr", bs.Ptr, "Ptr", be.Ptr) ; EM_GETSEL
    s := NumGet(bs, 0, "UInt"), e := NumGet(be, 0, "UInt")
    return h
}

Notepad_SetSel(h, s, e) {
    DllCall("SendMessageW", "Ptr", h, "UInt", 0x00B1, "Ptr", s, "Ptr", e) ; EM_SETSEL
}

Notepad_ReplaceSel(h, text) {
    DllCall("SendMessageW", "Ptr", h, "UInt", 0x00C2, "Ptr", 1, "Ptr", StrPtr(text)) ; EM_REPLACESEL
}

Notepad_GetText() {
    return ControlGetText("Edit1", "A")
}

IsDelimChar(ch) {
    ; Keep minimal delimiters for token scanning
    return (ch=" " || ch="`t" || ch="`r" || ch="`n" || ch="." || ch="," || ch=";" || ch=":" || ch="]" || ch="}" || ch="'" || ch='"')
}

Notepad_GetTokenAtCaret(&token, &start0, &end0) {
    token := "", start0 := 0, end0 := 0

    h := Notepad_GetSel(&s, &e)
    caret := e

    txt := Notepad_GetText()
    len := StrLen(txt)
    if (caret > len)
        caret := len

    i := caret
    while (i > 0) {
        ch := SubStr(txt, i, 1) ; SubStr is 1-based
        if (IsDelimChar(ch))
            break
        i -= 1
    }

    start0 := i
    end0 := caret
    tokenLen := end0 - start0
    if (tokenLen <= 0)
        return false

    token := SubStr(txt, start0 + 1, tokenLen)
    if (token = "" || StrLen(token) > 80 || RegExMatch(token, "\s"))
        return false

    return true
}

ConvertCurrentToken_Notepad() {
    global gMode
    h := Notepad_GetSel(&s, &e)

    token := "", start0 := 0, end0 := 0
    if (!Notepad_GetTokenAtCaret(&token, &start0, &end0))
        return

    converted := ConvertToken(token, gMode)
    if (converted = "")
        return

    Notepad_SetSel(h, start0, end0)
    Notepad_ReplaceSel(h, converted)
    newPos := start0 + StrLen(converted)
    Notepad_SetSel(h, newPos, newPos)

    HideSug()
}

; ============================================================
; Clipboard fallback (other apps)
; ============================================================

ConvertPreviousToken_Clipboard() {
    global gMode
    clipSaved := ClipboardAll()
    A_Clipboard := ""

    Send("^+{Left}")
    Sleep(15)
    Send("^c")
    if !ClipWait(0.25) {
        A_Clipboard := clipSaved
        Send("{Right}")
        return
    }

    token := Trim(A_Clipboard, " `t`r`n")
    if (token = "" || StrLen(token) > 80 || RegExMatch(token, "\s")) {
        A_Clipboard := clipSaved
        Send("{Right}")
        return
    }

    converted := ConvertToken(token, gMode)
    A_Clipboard := (converted != "" && converted != token) ? converted : token
    Send("^v")
    Sleep(10)
    A_Clipboard := clipSaved
}


; ============================================================
; Node exec + conversion (UTF-8 safe)
; ============================================================

ExecCaptureUtf8(rawCmd) {
    ; WScript.Shell Exec often mangles UTF-8 (Vietnamese) into mojibake like "báº£ng".
    ; Fix: redirect stdout to a temp file and read it as UTF-8.
    outFile := A_Temp "\cvnss_out_" A_TickCount ".txt"
    errFile := A_Temp "\cvnss_err_" A_TickCount ".txt"

    full := 'cmd /c chcp 65001>nul & ' rawCmd ' 1>"' outFile '" 2>"' errFile '"'
    code := RunWait(full, , "Hide")

    out := ""
    try out := FileRead(outFile, "UTF-8")
    catch
        out := ""

    ; cleanup
    try FileDelete(outFile)
    try FileDelete(errFile)

    return { out: out, code: code }
}

QuoteIfNeeded(pathOrCmd) {
    if (InStr(pathOrCmd, " "))
        return '"' pathOrCmd '"'
    return pathOrCmd
}

ConvertToken(token, mode) {
    global gNode, gConvertCli
    if (gConvertCli = "")
        return ""

    tok := StrReplace(token, '"', '\"')
    nodePart := QuoteIfNeeded(gNode)
    raw := nodePart ' "' gConvertCli '" ' mode ' "' tok '"'
    r := ExecCaptureUtf8(raw)
    if (r.code != 0)
        return ""
    return FixMojibakeIfNeeded(Trim(r.out, "`r`n"))
}

GetSuggestions(token, mode, n := 6) {
    global gNode, gSuggestCli
    if (gSuggestCli = "")
        return []

    tok := StrReplace(token, '"', '\"')
    nodePart := QuoteIfNeeded(gNode)
    raw := nodePart ' "' gSuggestCli '" ' mode ' "' tok '" ' n
    r := ExecCaptureUtf8(raw)
    j := Trim(r.out, " `t`r`n")

    arr := []
    pos := 1
    while RegExMatch(j, '"((?:\\\"|[^"])*)"', &m, pos) {
        s := StrReplace(m[1], '\"', '"')
        if (s != "")
            arr.Push(FixMojibakeIfNeeded(s))
        pos := m.Pos + m.Len
        if (arr.Length >= n)
            break
    }
    return arr
}




; ============================================================
; Suggestion UI (Notepad-first)
; ============================================================

EnsureSugGui() {
    global gSugGui, gSugTextCtl
    if (gSugGui)
        return
    gSugGui := Gui("+AlwaysOnTop -Caption +ToolWindow +Border")
    gSugGui.SetFont("s10", "Segoe UI")
    gSugTextCtl := gSugGui.AddText("cFFFFFF BackgroundTrans", "")
    gSugGui.BackColor := "202020"
}

UpdateSuggest() {
    global gEnabled, gNotepadOnly, gMode, gSugVisible, gLastToken, gLastCaret, gSug

    if (!gEnabled) {
        HideSug()
        return
    }
    if (gNotepadOnly && !IsNotepadReady()) {
        HideSug()
        return
    }
    if (!IsNotepadReady()) {
        HideSug()
        return
    }

    token := "", s0 := 0, e0 := 0
    if (!Notepad_GetTokenAtCaret(&token, &s0, &e0)) {
        HideSug()
        return
    }

    caret := e0
    if (token = gLastToken && caret = gLastCaret)
        return

    gLastToken := token
    gLastCaret := caret

    cands := GetSuggestions(token, gMode, 6)
    if (cands.Length = 0) {
        HideSug()
        return
    }

    gSug := cands
    ShowSug(cands)
}

ShowSug(cands) {
    global gSugVisible, gSugTextCtl

    EnsureSugGui()

    line := ""
    for i, w in cands {
        if (i = 1)
            line .= "[" i "] " w "   "
        else
            line .= i ": " w "   "
        if (i >= 6)
            break
    }

    gSugTextCtl.Value := line

    if (GetCaretScreenPos(&x, &y)) {
        gSugGui.Show("x" x " y" y " NoActivate AutoSize")
        gSugVisible := true
    } else {
        HideSug()
    }
}

HideSug() {
    global gSugVisible, gSugGui
    if (gSugGui) {
        try gSugGui.Hide()
    }
    gSugVisible := false
}

AcceptSug(n) {
    global gSug, gSugVisible
    if (!gSugVisible)
        return
    if (n < 1 || n > gSug.Length)
        return
    if (!IsNotepadReady()) {
        HideSug()
        return
    }

    chosen := gSug[n]
    if (chosen = "") {
        HideSug()
        return
    }

    h := Notepad_GetSel(&s, &e)
    token := "", s0 := 0, e0 := 0
    if (!Notepad_GetTokenAtCaret(&token, &s0, &e0)) {
        HideSug()
        return
    }

    Notepad_SetSel(h, s0, e0)
    Notepad_ReplaceSel(h, chosen)
    newPos := s0 + StrLen(chosen)
    Notepad_SetSel(h, newPos, newPos)

    HideSug()
}

GetCaretScreenPos(&x, &y) {
    hwnd := WinGetID("A")
    if (!hwnd)
        return false

    tid := DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "Ptr", 0, "UInt")
    cb := (A_PtrSize = 8) ? 72 : 48
    gti := Buffer(cb, 0)
    NumPut("UInt", cb, gti, 0)

    ok := DllCall("GetGUIThreadInfo", "UInt", tid, "Ptr", gti.Ptr)
    if (!ok)
        return false

    ; rcCaret offset (based on AHK docs & structure):
    offRc := 8 + 6 * A_PtrSize
    left := NumGet(gti, offRc + 0, "Int")
    top  := NumGet(gti, offRc + 4, "Int")

    hwndCaret := NumGet(gti, 8 + 5 * A_PtrSize, "Ptr")
    if (!hwndCaret)
        hwndCaret := hwnd

    pt := Buffer(8, 0)
    NumPut("Int", left, pt, 0)
    NumPut("Int", top,  pt, 4)
    DllCall("ClientToScreen", "Ptr", hwndCaret, "Ptr", pt.Ptr)
    sx := NumGet(pt, 0, "Int")
    sy := NumGet(pt, 4, "Int")

    x := sx
    y := sy - 28
    if (y < 0)
        y := sy + 22
    return true
}
