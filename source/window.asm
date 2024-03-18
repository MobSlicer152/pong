        bits 64

        %include "pong.inc"
        %include "win32.inc"

        section .text

        global SetupWindow
SetupWindow:
; Stack setup
        push rbp
        mov rbp, rsp

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
        mov r13, sizeof(WNDCLASSEXW)    ; sizeof(WNDCLASSEXW) -> cbSize
        mov dword [r12 + WNDCLASSEXW.cbSize], r13d
        lea r13, [rel WindowProcedure]  ; WindowProcedure -> lpfnWndProc
        mov qword [r12 + WNDCLASSEXW.lpfnWndProc], r13
        lea r13, [rel className]        ; className -> lpszClassName
        mov qword [r12 + WNDCLASSEXW.lpszClassName], r13

; GetModuleHandleA(NULL) -> hInstance
        sub rsp, 32
        xor eax, eax
        call GetModuleHandleA
        add rsp, 32
        mov qword [r12 + WNDCLASSEXW.hInstance], rax

; RegisterClassExW
        sub rsp, 32                     ; Shadow space
        mov rcx, r12                    ; Window class structure
        call RegisterClassExW
        add rsp, 32                     ; Clear shadow space

; CreateWindowExW
        sub rsp, 80
        xor ecx, ecx                    ; No extended styles
        mov rdx, qword [r12 + WNDCLASSEXW.lpszClassName]
        lea r8, [rel windowName]        ; Window name
        mov r9, WS_OVERLAPPEDWINDOW     ; Generic window style
        mov r13, CW_USEDEFAULT          ; CW_USEDEFAULT for X, Y, nWidth, nHeight
        mov dword [rsp + 32 + 0], r13d  ; X
        mov dword [rsp + 32 + 4], r13d  ; Y
        mov dword [rsp + 32 + 8], r13d  ; nWidth
        mov dword [rsp + 32 + 12], r13d ; nHeight
        mov qword [rsp + 32 + 20], rcx  ; hWndParent
        mov qword [rsp + 32 + 28], rcx  ; hMenu
        mov qword [rsp + 32 + 36], rcx  ; hInstance
        mov qword [rsp + 32 + 44], rcx  ; lParam
        call CreateWindowExW
        add rsp, 80

; Check window
        cmp rax, 0
        jne .success

.error:
        sub rsp, 32
        call GetLastError
        add rsp, 32
        mov ecx, eax
        call ExitProcess
.success:
        mov [rel window], rax
        mov rcx, [rel window]
        mov edx, SW_SHOWNORMAL
        call ShowWindow

; Stack cleanup
        add rsp, sizeof(WNDCLASSEXW)

        pop r13
        pop r12

        pop rbp
        ret

        global WindowProcedure
WindowProcedure:
        push rbp
        mov rbp, rsp

        mov eax, 0

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
window:
        resq 1
