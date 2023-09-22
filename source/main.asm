	bits 64

	%include "nt.inc"
	%include "pong.inc"
	%include "window.inc"

	section .text
	global mainCRTStartup
mainCRTStartup:
	push rbp
	mov rbp, rsp

	sub rsp, 32
	call SetupWindow
	add rsp, 32

	mov rcx, NtCurrentProcess()
	mov edx, STATUS_SUCCESS
	call NtTerminateProcess
