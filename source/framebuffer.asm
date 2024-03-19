        bits 64

        %include "pong.inc"
        %include "win32.inc"
        %include "window.inc"

        section .text
        global SetupFramebuffer
SetupFramebuffer:
        push rbp
        mov rbp, rsp



        pop rbp
        ret


        global DestroyFramebuffer
DestroyFramebuffer:
        push rbp
        mov rbp, rsp



        pop rbp
        ret


        section .bss
windowDc:
        resq 1
framebufferDc:
        resq 1
framebuffer:
        resq 1
framebufferBitmapInfo:
        resb sizeof(BITMAPINFOHEADER)