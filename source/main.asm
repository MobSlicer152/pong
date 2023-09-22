	bits 64

	%include "nt.inc"
	%include "pong.inc"
	%include "window.inc"

	section .text
	global mainCRTStartup
mainCRTStartup:
	sub rsp, 8						; Align to 16 bytes

	push rbp
	mov rbp, rsp

	sub rsp, 32
	call SetupWindow
	add rsp, 32

	mov rcx, NtCurrentProcess()
	mov edx, STATUS_SUCCESS
	xor r8, r8
	xor r9, r9
	call NtTerminateProcess
