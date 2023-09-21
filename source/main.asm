	bits 64

	%include "nt.inc"
	%include "pong.inc"
	%include "window.inc"

	section .text
	global mainCRTStartup
mainCRTStartup:
	push rbp
	mov rbp, rsp

	call SetupWindow

	mov rcx, NtCurrentProcess()
	mov edx, STATUS_SUCCESS
	xor r8, r8
	xor r9, r9
	call NtTerminateProcess
