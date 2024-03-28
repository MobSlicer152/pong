        bits 64

        %include "pong.inc"
        %include "win32.inc"

        section .text

        global SetupWindow
SetupWindow:
; Stack setup
        push rbp
        mov  rbp, rsp

        push r12
        push r13

; Variables
        sub rsp, sizeof(WNDCLASSEXW)

; Clear WNDCLASSEXW
        cld
        mov r12, rsp
        mov rdi, r12
        xor eax, eax
        mov ecx, sizeof(WNDCLASSEXW)
        rep stosb

; Set WNDCLASSEXW fields
        mov eax,                                     sizeof(WNDCLASSEXW)   ; sizeof(WNDCLASSEXW) -> cbSize
        mov dword [r12 + WNDCLASSEXW.cbSize],        eax
        lea r13,                                     [rel WindowProcedure] ; WindowProcedure -> lpfnWndProc
        mov qword [r12 + WNDCLASSEXW.lpfnWndProc],   r13
        lea r13,                                     [rel className]       ; className -> lpszClassName
        mov qword [r12 + WNDCLASSEXW.lpszClassName], r13

; GetModuleHandleA(NULL) -> hInstance
        sub  rsp,                                 32
        xor  eax,                                 eax
        call GetModuleHandleA
        add  rsp,                                 32
        mov  qword [r12 + WNDCLASSEXW.hInstance], rax

; RegisterClassExW
        sub  rsp, 32          ; Shadow space
        mov  rcx, r12         ; Window class structure
        call RegisterClassExW
        add  rsp, 32          ; Clear shadow space

; CreateWindowExW
        sub  rsp,                   80
        xor  ecx,                   ecx                                     ; No extended styles
        mov  rdx,                   qword [r12 + WNDCLASSEXW.lpszClassName]
        lea  r8,                    [rel windowName]                        ; Window name
        mov  r9,                    PONG_STYLE
        mov  r13,                   CW_USEDEFAULT                           ; CW_USEDEFAULT for X, Y, nWidth, nHeight
        mov  qword [rsp + 32 + 0],  r13                                     ; X
        mov  qword [rsp + 32 + 8],  r13                                     ; Y
        mov  qword [rsp + 32 + 16], r13                                     ; nWidth
        mov  qword [rsp + 32 + 24], r13                                     ; nHeight
        mov  qword [rsp + 32 + 32], rcx                                     ; hWndParent
        mov  qword [rsp + 32 + 40], rcx                                     ; hMenu
        mov  r13,                   qword [r12 + WNDCLASSEXW.hInstance]
        mov  qword [rsp + 32 + 48], r13                                     ; hInstance
        mov  qword [rsp + 32 + 56], rcx                                     ; lpParam
        call CreateWindowExW
        add  rsp,                   80

; Check window
        cmp rax, 0
        jne .success

.error:
        sub  rsp, 32
        call GetLastError
        mov  ecx, eax
        call ExitProcess
.success:
        mov  [rel g_window], rax
        sub  rsp,            32
        mov  rcx,            [rel g_window]
        mov  edx,            SW_SHOWNORMAL
        call ShowWindow
        add  rsp,            32

; Get size (and save the address of the RECT in r12, because it's overwritten)
        sub  rsp, 32 + sizeof(RECT)
        mov  rcx, qword [rel g_window]
        mov  rdx, rsp
        add  rdx, 32
        mov  r12, rdx
        call GetClientRect
        add  rsp, 32

        mov edx,                  dword [r12 + RECT.right]
        sub edx,                  dword [r12 + RECT.left]
        mov dword [rel g_width],  edx
        mov edx,                  dword [r12 + RECT.bottom]
        sub edx,                  dword [r12 + RECT.top]
        mov dword [rel g_height], edx

; Stack cleanup
        add rsp, sizeof(WNDCLASSEXW) + sizeof(RECT)

        pop r13
        pop r12

        pop rbp
        ret


; Has the message loop
        global ProcessMessages
ProcessMessages:
        push rbp
        mov  rbp, rsp

        push r12

        sub rsp, sizeof(MSG)
        mov r12, rsp

.messageLoop:
        sub  rsp,                  40
        mov  rcx,                  r12
        xor  edx,                  edx
        xor  r8,                   r8
        xor  r9,                   r9
        mov  eax,                  PM_REMOVE
        mov  qword [rsp + 32 + 0], rax
        call PeekMessageW
        add  rsp,                  40
        cmp  eax,                  0
        je   .messageLoopEnd

        sub  rsp, 32
        mov  rcx, r12
        call TranslateMessage
        add  rsp, 32

        sub  rsp, 32
        mov  rcx, r12
        call DispatchMessageW
        add  rsp, 32

        jmp .messageLoop
.messageLoopEnd:

; EAX is already zero because PeekMessageW has to return 0 to get here
; return !windowClosed
        mov  al, byte [rel windowClosed]
        test al, al
        setz al

        add rsp, sizeof(MSG)

        pop r12

        pop rbp
        ret


; Window procedure, pretty basic
        global WindowProcedure
WindowProcedure:
        push rbp
        mov  rbp, rsp

        cmp edx, WM_SIZE
        je  .handleSize
        cmp edx, WM_CLOSE
        je  .handleClose
        cmp edx, WM_DESTROY
        je  .handleClose
        jmp .handleOther

.handleSize:
        sub  rsp, 32 + sizeof(RECT)
        mov  rcx, qword [rel g_window]
        mov  rdx, rsp
        add  rdx, 32
        mov  r12, rdx
        call GetClientRect
        add  rsp, 32

        mov edx,                  dword [r12 + RECT.right]
        sub edx,                  dword [r12 + RECT.left]
        mov dword [rel g_width],  edx
        mov edx,                  dword [r12 + RECT.bottom]
        sub edx,                  dword [r12 + RECT.top]
        mov dword [rel g_height], edx

        add rsp, sizeof(RECT)

        xor eax, eax
        jmp .return
.handleClose:
        mov eax,                     1
        mov byte [rel windowClosed], al
        xor eax,                     eax
        jmp .return
.handleOther:
        sub  rsp, 32
        call DefWindowProcW
        add  rsp, 32
        jmp  .return

.return:
        pop rbp
        ret


        section .data
className:
        dw L("PongClass"), 0
.size:
        dq $ - className
windowName:
        dw L("Pong"), 0
.size:
        dq $ - windowName


        section .bss

        global g_window
g_window:
        resq 1

        global g_width
g_width:
        resd 1

        global g_height
g_height:
        resd 1

windowClosed:
        resb 1
