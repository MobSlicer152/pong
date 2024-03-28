        bits 64

        %include "pong.inc"

        %include "framebuffer.inc"
        %include "win32.inc"
        %include "window.inc"


        section .text

        global mainCRTStartup
mainCRTStartup:
        push rbp
        mov  rbp, rsp

        sub  rsp, 32
        call SetupWindow
        add  rsp, 32

        sub  rsp, 32
        call SetupFramebuffer
        add  rsp, 32

.mainLoop:
        sub  rsp, 32
        call ProcessMessages
        add  rsp, 32
        test eax, eax
        jz   .mainLoopEnd

        call DisplayFramebuffer

        jmp .mainLoop
.mainLoopEnd:

        sub  rsp, 32
        mov  ecx, 0      ; No error
        call ExitProcess
