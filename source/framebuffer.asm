        bits 64

        %include "pong.inc"
        %include "win32.inc"
        %include "window.inc"

        section .text
        global  SetupFramebuffer
SetupFramebuffer:
; Stack setup
        push rbp
        mov  rbp, rsp

        push r12
        push r13

; Get extra width and height to account for when displaying the framebuffer
        sub rsp,                       32 + sizeof(RECT)
        mov r12,                       rsp
        add rcx,                       32
        xor eax,                       eax
        mov dword [r12 + RECT.left],   eax
        mov eax,                       [rel g_width]
        mov dword [r12 + RECT.right],  eax
        xor eax,                       eax
        mov dword [r12 + RECT.top],    eax
        mov eax,                       [rel g_height]
        mov dword [r12 + RECT.bottom], eax

        mov  rcx, r12
        mov  edx, PONG_STYLE
        xor  r8,  r8
        call AdjustWindowRect
        add  rsp, 32

; Basically, 0 - adjustedClientArea.left and 0 - adjustedClientArea.right
        mov eax,               [r12 + RECT.left]
        neg eax
        mov [rel extraWidth],  eax
        mov eax,               [r12 + RECT.top]
        neg eax
        mov [rel extraHeight], eax

        add rsp, sizeof(RECT)

; Set BITMAPINFOHEADER
        lea r12,                                          [rel framebufferBitmapInfo]
        mov eax,                                          sizeof(BITMAPINFOHEADER)
        mov dword [r12 + BITMAPINFOHEADER.biSize],        eax
        mov eax,                                          FRAMEBUFFER_WIDTH
        mov dword [r12 + BITMAPINFOHEADER.biWidth],       eax
        mov eax,                                          FRAMEBUFFER_HEIGHT
        mov dword [r12 + BITMAPINFOHEADER.biHeight],      eax
        mov eax,                                          BI_RGB
        mov dword [r12 + BITMAPINFOHEADER.biCompression], eax
        mov eax,                                          32
        mov word [r12 + BITMAPINFOHEADER.biBitCount],     ax
        mov eax,                                          1
        mov word [r12 + BITMAPINFOHEADER.biPlanes],       ax

; Device context
        mov  rcx,            [rel g_window]
        call GetWindowDC
        mov  [rel windowDc], rax

        mov  rcx,                 [rel windowDc]
        call CreateCompatibleDC
        mov  [rel framebufferDc], rax

; Framebuffer
        sub  rsp,                  32 + 12
        mov  rcx,                  [rel framebufferDc]
        mov  rdx,                  r12                 ; &framebufferBitmapInfo
        xor  r8,                   r8
        lea  r9,                   [rel framebuffer]
        mov  qword [rsp + 32 + 0], r8
        mov  dword [rsp + 32 + 8], r8d
        call CreateDIBSection
        add  rsp,                  32 + 12

; Error check
        cmp rax, 0
        jne .success

.error:
        sub  rsp, 32
        call GetLastError
        mov  ecx, eax
        call ExitProcess
.success:
        mov  [rel framebufferBitmap], rax
        sub  rsp,                     32
        mov  rcx,                     [rel framebufferDc]
        mov  rdx,                     rax
        call SelectObject
        add  rsp,                     32

        pop r13
        pop r12

        pop rbp
        ret


        global DisplayFramebuffer
DisplayFramebuffer:
        push rbp
        mov  rbp, rsp

        sub  rsp,                   32 + 72
        mov  rcx,                   [rel windowDc] ; hdc = windowDc
        mov  edx,                   [rel extraWidth] ; xDest = extraWidth
        mov  r8d,                   [rel extraHeight] ; yDest = height + extraHeight
        add  r8d,                   [rel g_height]
        mov  r9d,                   [rel g_width] ; DestWidth = width
        mov  eax,                   [rel g_height] ; DestHeight = -height
        neg  eax
        mov  dword [rsp + 32 + 0],  eax
        xor  eax,                   eax
        mov  dword [rsp + 32 + 8],  eax ; xSrc = 0
        mov  dword [rsp + 32 + 16], eax ; ySrc = 0
        mov  eax,                   FRAMEBUFFER_WIDTH
        mov  dword [rsp + 32 + 24], eax ; SrcWidth = FRAMEBUFFER_WIDTH
        mov  eax,                   FRAMEBUFFER_HEIGHT
        mov  dword [rsp + 32 + 32], eax ; SrcHeight = FRAMEBUFFER_HEIGHT
        mov  rax,                   [rel framebuffer]
        mov  qword [rsp + 32 + 40], rax ; lpBits = framebuffer
        lea  rax,                   [rel framebufferBitmapInfo]
        mov  qword [rsp + 32 + 48], rax ; lpbmi = &framebufferBitmapInfo
        mov  eax,                   DIB_RGB_COLORS
        mov  dword [rsp + 32 + 56], eax ; iUsage = DIB_RGB_COLORS
        mov  eax,                   SRCCOPY
        mov  dword [rsp + 32 + 64], eax ; rop = SRCCOPY
        call StretchDIBits2
        add  rsp,                   32 + 72

        pop rbp
        ret


        section .bss
extraWidth:
        resd 1
extraHeight:
        resd 1
windowDc:
        resq 1
framebufferDc:
        resq 1
framebuffer:
        resq 1
framebufferBitmap:
        resq 1
framebufferBitmapInfo:
        resb sizeof(BITMAPINFOHEADER)