							; Structures
struc UNICODE_STRING
	.MaximumLength resw 1
	.Length	resw 1
	.Buffer	resq 1
endstruc

struc WNDCLASSEX
	.cbSize resd 1
	.style resd 1
	.lpfnWndProc resq 1
	.cbClsExtra resd 1
	.cbWndExtra resd 1
	.hInstance resq 1
	.hIcon resq 1
	.hCursor resq 1
	.hbrBackground resq 1
	.lpszMenuName resq 1
	.lpszClassName resq 1
	.hIconSm resq 1
endstruc

struc PEB
	.InheritedAddressSpace resb 1
	.ReadImageFileExecOptions resb 1
	.BeingDebugged resb 1
	.BitField resb 1
	.Mutant resq 1
	.ImageBaseAddress resq 1
	.Ldr resq 1
	.ProcessParameters resq 1
	.Unused resb 7b6h				; 7d0 - 1a
endstruc

							; Misc
	%define NtCurrentProcess() -1
	%define NtCurrentTeb() qword gs:[30h]
	%define NtCurrentPeb() qword gs:[60h]
	%define CW_USEDEFAULT 80000000h
	%define SW_SHOWNORMAL 1

							; Window styles
	%define WS_CAPTION 00c00000h
	%define WS_MAXIMIZEBOX 00010000h
	%define WS_MINIMIZEBOX 00020000h
	%define WS_OVERLAPPED 0000000h
	%define WS_SYSMENU 00080000h
	%define WS_THICKFRAME 00040000h
	%define WS_OVERLAPPEDWINDOW (WS_OVERLAPPED | \
		WS_CAPTION | WS_SYSMENU | \
		WS_THICKFRAME | WS_MINIMIZEBOX | \
		WS_MAXIMIZEBOX)

							; NTSTATUS codes
	%define STATUS_SUCCESS 0

							; NTDLL imports
	extern NtTerminateProcess			; NTSTATUS NtTerminateProcess(HANDLE Process, NTSTATUS ExitStatus);

							; User32 imports
	extern RegisterClassExW				; ATOM WINAPI RegisterClassExW( const WNDCLASSEXW *wc )
	extern CreateWindowExW				; HWND CreateWindowExW( [in] DWORD dwExStyle, [in, optional] LPCWSTR lpClassName,
							;     [in, optional] LPCWSTR lpWindowName, [in] DWORD dwStyle, [in] int X, [in] int Y,
							;     [in] int nWidth, [in] int nHeight, [in, optional] HWND hWndParent,
							;     [in, optional] HMENU hMenu, [in, optional] HINSTANCE hInstance,
							;     [in, optional] LPVOID lpParam );
	extern ShowWindow				; BOOL ShowWindow( [in] HWND hWnd, [in] int nCmdShow );

