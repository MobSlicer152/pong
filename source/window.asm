	bits 64

	%include "nt.inc"

	section .text

	global SetupWindow
SetupWindow:
	push rbp
	mov rbp, rsp

	pop rbp
	ret
