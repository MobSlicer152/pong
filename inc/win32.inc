; kernel32
        extern ExitProcess
		extern GetLastError
		extern GetModuleHandleA

; user32
    	extern CreateWindowExW
    	extern RegisterClassExW
    	extern ShowWindow

		struc WNDCLASSEXW
			.cbSize: resd 1
			.style: resd 1
			.lpfnWndProc: resq 1
			.cbClsExtra: resd 1
			.cbWndExtra: resd 1
			.hInstance: resq 1
			.hIcon: resq 1
			.hCursor: resq 1
			.hbrBackground: resq 1
			.lpszMenuName: resq 1
			.lpszClassName: resq 1
			.hIconSm: resq 1
		endstruc

		%define CW_USEDEFAULT 80000000h

		%define SW_SHOWNORMAL 1

		%define WS_CAPTION 00C00000h
		%define WS_MAXIMIZEBOX 00010000h
		%define WS_MINIMIZEBOX 00020000h
		%define WS_OVERLAPPED 00000000h
		%define WS_SYSMENU 00080000h
		%define WS_THICKFRAME 00040000h

		%define WS_OVERLAPPEDWINDOW (WS_CAPTION | WS_MAXIMIZEBOX | WS_MINIMIZEBOX | \
				WS_OVERLAPPED | WS_SYSMENU | WS_THICKFRAME)
