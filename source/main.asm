        bits 64

        %include "nasmx.inc"
        %include "win32/kernel32.inc"
        %include "win32/windows.inc"
        %include "pong.inc"
        %include "window.inc"

        extern ExitProcess

        section .text
        global mainCRTStartup
mainCRTStartup:
        push rbp
        mov rbp, rsp

        sub rsp, 32
        call SetupWindow
        add rsp, 32

        sub rsp, 32
        mov ecx, 0                     ; No error
        call ExitProcess
