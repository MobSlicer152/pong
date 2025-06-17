bits 32

%include "pong.inc"

; WS_OVERLAPPEDWINDOW but not resizable (no MAXIMIZEBOX or THICKFRAME)
%define WINDOW_STYLE 00c00000h | 00020000h | 00080000h
%define WM_CLOSE 10h

section .data

WINDOW_CLASS: db "PongWnd", 0
WINDOW_TITLE: db "Pong", 0

section .bss

windowClass: resb sizeof(WNDCLASSEXA)
window: resd 1

section .text

global InitWindow
InitWindow:
    push ebp
    mov ebp, esp

    ; set up the window class
    lea edi, windowClass
    mov eax, sizeof(WNDCLASSEXA)
    mov dword [edi + WNDCLASSEXA.cbSize], eax
    lea eax, _WindowProc@16
    mov dword [edi + WNDCLASSEXA.lpfnWndProc], eax
    mov eax, WINDOW_CLASS
    mov dword [edi + WNDCLASSEXA.lpszClassName], eax

    push dword 0
    call _GetModuleHandleA@4
    mov dword [edi + WNDCLASSEXA.hInstance], eax

    push dword 32512
    push dword 0
    call _LoadCursorA@8
    mov dword [edi + WNDCLASSEXA.hCursor], eax

    ; zero other fields
    xor eax, eax
    mov dword [edi + WNDCLASSEXA.style], eax
    mov dword [edi + WNDCLASSEXA.cbClsExtra], eax
    mov dword [edi + WNDCLASSEXA.cbWndExtra], eax
    mov dword [edi + WNDCLASSEXA.hIcon], eax
    mov dword [edi + WNDCLASSEXA.hbrBackground], eax
    mov dword [edi + WNDCLASSEXA.lpszMenuName], eax
    mov dword [edi + WNDCLASSEXA.hIconSm], eax

    ; register the class
    push edi
    call _RegisterClassExA@4
    test eax, eax
    jnz .Registered
    call _GetLastError@0
    push eax
    call _ExitProcess@4

.Registered:
    ; create the window
    sub esp, 48
    mov dword [ebp - 48], 0 ; exStyle
    lea eax, WINDOW_CLASS
    mov dword [ebp - 44], eax ; class
    lea eax, WINDOW_TITLE
    mov dword [ebp - 40], eax ; name
    mov dword [ebp - 36], WINDOW_STYLE ; style
    mov dword [ebp - 32], CW_USEDEFAULT ; x
    mov dword [ebp - 28], CW_USEDEFAULT ; y
    mov dword [ebp - 24], WINDOW_WIDTH ; width
    mov dword [ebp - 20], WINDOW_HEIGHT ; height
    mov dword [ebp - 16], 0 ; parent
    mov dword [ebp - 12], 0 ; menu
    mov dword [ebp - 8], 0 ; hinstance
    mov dword [ebp - 4], 0 ; param
    call _CreateWindowExA@48
    test eax, eax
    jnz .Created
    call _GetLastError@0
    push eax
    call _ExitProcess@4

.Created:
    mov dword [window], eax

    push dword 1 ; SW_SHOWNORMAL
    push eax ; window
    call _ShowWindow@8

    mov byte [running], 1

    pop ebp
    ret 0

global UpdateWindow
UpdateWindow:
    push ebp
    mov ebp, esp

    sub esp, sizeof(MSG)
    mov edi, esp

.Loop:
    sub esp, 20
    mov dword [esp + 0], edi
    mov eax, dword [window]
    mov dword [esp + 4], eax
    xor eax, eax
    mov dword [esp + 8], eax
    mov dword [esp + 12], eax
    mov dword [esp + 16], 1 ; PM_REMOVE
    call _PeekMessageA@20
    test eax, eax
    jz .Done

    push edi
    call _TranslateMessage@4

    push edi
    call _DispatchMessageA@4
    jmp .Loop

.Done:
    add esp, sizeof(MSG)
    pop ebp
    ret 0

extern running

global _WindowProc@16
_WindowProc@16:
    push ebp
    mov ebp, esp

    mov ebx, esp
    add ebx, 8

    mov esi, dword [ebx + 4]

    cmp esi, WM_CLOSE
    je .Close

.Default:
    sub esp, 16
    mov eax, dword [ebx + 0] ; window
    mov dword [esp + 0], eax
    mov dword [esp + 4], esi ; msg
    mov eax, dword [ebx + 8] ; wparam
    mov dword [esp + 8], eax
    mov eax, dword [ebx + 12] ; lparam
    mov dword [esp + 12], eax
    call _DefWindowProcA@16
    jmp .Done

.Close:
    mov byte [running], 0
    xor eax, eax
    jmp .Done

.Done:
    pop ebp
    ret 16
