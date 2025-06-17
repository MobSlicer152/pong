bits 32

%include "pong.inc"

section .bss

global running
running: resb 1

section .text

extern InitWindow
extern UpdateWindow

global _WinMainCRTStartup
_WinMainCRTStartup:
    push ebp
    mov ebp, esp

    call InitWindow

.Loop:
    cmp byte [running], 0
    jz .Done

    call UpdateWindow

    jmp .Loop

.Done:
    push dword 0
    call _ExitProcess@4
