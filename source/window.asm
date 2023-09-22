	bits 64

	%include "nt.inc"
	%include "pong.inc"

	section .text

	global SetupWindow
SetupWindow:
													; Stack setup
	push rbp
	mov rbp, rsp

	push r12
	push r13
													; Variables
	sub rsp, sizeof(WNDCLASSEX)

													; Clear WNDCLASSEX
	cld
	mov r12, rsp
	mov rdi, r12
	xor eax, eax
	mov ecx, sizeof(WNDCLASSEX)
	rep stosb

	mov r13, sizeof(WNDCLASSEX)						; sizeof(WNDCLASSEX) -> cbSize
	mov dword [r12 + WNDCLASSEX.cbSize], r13d
	lea r13, [rel WindowProcedure]					; WindowProcedure -> lpfnWndProc
	mov qword [r12 + WNDCLASSEX.lpfnWndProc], r13
	lea r13, [rel className]						; className -> lpszClassName
	mov qword [r12 + WNDCLASSEX.lpszClassName], r13

                                                    ; RegisterClassExW
	sub rsp, 32									    ; Shadow space
	mov rcx, r12									; Window class structure
	call RegisterClassExW
	add rsp, 32										; Clear shadow space

													; Stack cleanup
	add rsp, sizeof(WNDCLASSEX)

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
	dw "PongClass", 0
.size:
	dq $ - className
windowName:
	dw "Pong"
.size:
	dq $ - windowName
