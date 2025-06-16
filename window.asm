bits 32

%include "pong.inc"

; WS_OVERLAPPEDWINDOW but not resizable (no MAXIMIZEBOX or THICKFRAME)
%define WINDOW_STYLE 00800000h | 00c00000h | 00020000h | 00080000h

section .data

WINDOW_CLASS: db "PongWnd", 0
WINDOW_TITLE: db "Pong", 0

section .bss

windowClass: istruc WNDCLASSEXA
window: resd 1

section .text

global _InitWindow
_InitWindow:
    push ebp
    mov ebp, esp

    ; set up the window class
    lea edi, windowClass
    mov eax, sizeof(WNDCLASSEXA)
    mov [edi + WNDCLASSEXA.cbSize], eax
    lea eax, _WindowProc@16
    mov [edi + WNDCLASSEXA.lpfnWndProc], eax
    mov eax, WINDOW_CLASS
    mov [edi + WNDCLASSEXA.lpszClassName], eax

    push dword 0
    call _GetModuleHandleA@4
    mov [edi + WNDCLASSEXA.hInstance], eax

    ; zero other fields
    xor eax, eax
    mov [edi + WNDCLASSEXA.style], eax
    mov [edi + WNDCLASSEXA.cbClsExtra], eax
    mov [edi + WNDCLASSEXA.cbWndExtra], eax
    mov [edi + WNDCLASSEXA.hIcon], eax
    mov [edi + WNDCLASSEXA.hCursor], eax
    mov [edi + WNDCLASSEXA.hbrBackground], eax
    mov [edi + WNDCLASSEXA.lpszMenuName], eax
    mov [edi + WNDCLASSEXA.hIconSm], eax

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
    push dword 0 ; param
    push dword 0 ; instance
    push dword 0 ; menu
    push dword 0 ; parent
    push dword WINDOW_HEIGHT
    push dword WINDOW_WIDTH
    push dword -1 ; y, cw_usedefault
    push dword -1 ; x, cw_usedefault
    push dword WINDOW_STYLE ; style
    push dword WINDOW_TITLE
    push dword WINDOW_CLASS
    push dword 0 ; ex style
    call _CreateWindowExA@48
    test eax, eax
    jnz .Created
    call _GetLastError@0
    push eax
    call _ExitProcess@4

.Created:
    mov [window], eax

    pop ebp
    ret

_WindowProc@16:
    push ebp
    mov ebp, esp

    call _DefWindowProcA@16

    pop ebp
    ret
