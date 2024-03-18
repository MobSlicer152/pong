        bits 64

        %include "pong.inc"
        %include "window.inc"
        %include "win32.inc"


        section .text

        global mainCRTStartup
mainCRTStartup:
        push rbp
        mov rbp, rsp

        sub rsp, 32
        call SetupWindow
        add rsp, 32

.mainLoop:
        sub rsp, 32
        call Update
        add rsp, 32
        test eax, eax
        jz .mainLoopEnd

        jmp .mainLoop
.mainLoopEnd:

        sub rsp, 32
        mov ecx, 0                     ; No error
        call ExitProcess
