	bits 64

	%include "nt.inc"

	section .text
	global mainCRTStartup
mainCRTStartup:
	push rbp
	mov rbp, rsp

	mov ecx, NtCurrentProcess
	xor edx, edx
	xor r8, r8
	xor r9, r9
	call NtTerminateProcess
