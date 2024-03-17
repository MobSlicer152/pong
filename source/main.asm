        bits 64

        %include "pong.inc"
        %include "window.inc"
        %include "win32.inc"

        section .text
        global mainCRTStartup
mainCRTStartup:
        push rbp
        mov rbp, rsp
        ALIGN 16

        sub rsp, 32
        call SetupWindow
        add rsp, 32

        sub rsp, 32
        mov ecx, 0                     ; No error
        call ExitProcess
