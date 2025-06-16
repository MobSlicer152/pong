bits 32

%include "pong.inc"

section .text

extern _InitWindow

global _WinMainCRTStartup
_WinMainCRTStartup:
    push ebp
    mov ebp, esp

    call _InitWindow

    push dword 0
    call _ExitProcess@4
