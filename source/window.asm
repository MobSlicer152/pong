        bits 64

        %include "nasmx.inc"
        %include "win32/kernel32.inc"
        %include "win32/user32.inc"
        %include "pong.inc"

        extern RegisterClassExW
        extern CreateWindowExW
        extern ExitProcess
        extern ShowWindow

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

        mov r13, sizeof(WNDCLASSEXW)    ; sizeof(WNDCLASSEXW) -> cbSize
        mov dword [r12 + WNDCLASSEXW.cbSize], r13d
        lea r13, [rel WindowProcedure] ; WindowProcedure -> lpfnWndProc
        mov qword [r12 + WNDCLASSEXW.lpfnWndProc], r13
        lea r13, [rel className]       ; className -> lpszClassName
        mov qword [r12 + WNDCLASSEXW.lpszClassName], r13

; RegisterClassExW
        sub rsp, 32                    ; Shadow space
        mov rcx, r12                   ; Window class structure
        call RegisterClassExW
        add rsp, 32                    ; Clear shadow space

; CreateWindowExW
        sub rsp, 32 + 4 + 4 + 4 + 4 + 8 + 8 + 8 + 8
        xor ecx, ecx                   ; No extended styles
        mov rdx, qword [r12 + WNDCLASSEXW.lpszClassName] ; Class name
        lea r8, [rel windowName]       ; Window name
        mov r9, WS_OVERLAPPEDWINDOW    ; Generic window style
        mov r13, CW_USEDEFAULT         ; CW_USEDEFAULT for X, Y, nWidth, nHeight
        mov dword [rsp + 44], r13d
        mov dword [rsp + 40], r13d
        mov dword [rsp + 36], r13d
        mov dword [rsp + 32], r13d
        mov qword [rsp + 24], rcx      ; RCX is already zeroed, and rest of parameters are NULL
        mov qword [rsp + 16], rcx
        mov qword [rsp + 8], rcx
        mov qword [rsp + 0], rcx
        call CreateWindowExW
        add rsp, 32

; Check window
        cmp rax, 0
        jne .success

.error:
        mov ecx, 1
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
