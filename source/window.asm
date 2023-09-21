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

								; Allocate and clear WNDCLASSEX
	cld
	sub rsp, sizeof(WNDCLASSEX)
	mov r12, rsp
	mov rdi, r12
	xor eax, eax
	mov ecx, sizeof(WNDCLASSEX)
	rep stosb

	mov r13, sizeof(WNDCLASSEX)				; sizeof(WNDCLASSEX) -> cbSize
	mov dword [r12 + WNDCLASSEX.cbSize], r13d
	mov r13, [WindowProcedure]				; WindowProcedure -> lpfnWndProc
	mov qword [r12 + WNDCLASSEX.lpfnWndProc], r13
	mov r13, NtCurrentPeb()					; PEB->ImageBaseAddress -> hInstance
	mov r13, qword [r13 + PEB.ImageBaseAddress]
	mov qword [r12 + WNDCLASSEX.hInstance], r13
		lea r13, [className]				; className -> lpszClassName
	mov qword [r12 + WNDCLASSEX.lpszClassName], r13

	mov rcx, r13
	xor edx, edx
	xor r8, r8
	xor r9, r9

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
