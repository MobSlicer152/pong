						; Structures
struc UNICODE_STRING
	.MaximumLength: resw 1
	.Length: resw 1
	.Buffer: resq 1
endstruc

						; Misc
	%define NtCurrentProcess -1

						; NTSTATUS codes
	%define STATUS_SUCCESS 0

						; Imports
	extern NtTerminateProcess		; NTSTATUS NtTerminateProcess(HANDLE Process, NTSTATUS ExitStatus);
