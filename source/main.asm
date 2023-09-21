	bits 64

	%include "nt.inc"

	section .text
	global mainCRTStartup
mainCRTStartup:
	push rbp
	mov rbp, rsp

	mov rcx, NtCurrentProcess
	mov edx, STATUS_INVALID_PARAMETER
	xor r8, r8
	xor r9, r9
	call NtTerminateProcess
