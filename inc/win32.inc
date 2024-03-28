; kernel32
        extern ExitProcess
        extern GetLastError
        extern GetModuleHandleA

; gdi32
        extern CreateCompatibleDC
        extern CreateDIBSection
        extern DeleteDC
        extern DeleteObject
        extern GetWindowDC
        extern ReleaseDC
        extern SelectObject
        extern StretchDIBits2

; user32
        extern AdjustWindowRect
        extern CreateWindowExW
        extern DefWindowProcW
        extern DispatchMessageW
        extern GetClientRect
        extern PeekMessageW
        extern RegisterClassExW
        extern ShowWindow
        extern TranslateMessage

        struc BITMAPINFOHEADER
                .biSize:          resd 1
                .biWidth:         resd 1
                .biHeight:        resd 1
                .biPlanes:        resw 1
                .biBitCount:      resw 1
                .biCompression:   resd 1
                .biSizeImage:     resd 1
                .biXPelsPerMeter: resd 1
                .biYPelsPerMeter: resd 1
                .biClrUsed:       resd 1
                .biClrImportant:  resd 1
        endstruc

        struc MSG
                .hwnd:    resq 1
                .message: resd 1
                .wParam:  resq 1
                .lParam:  resq 1
                .time:    resd 1
                .pt:      resd 2
        endstruc

        struc RECT
                .left:   resd 1
                .top:    resd 1
                .right:  resd 1
                .bottom: resd 1
        endstruc

        struc WNDCLASSEXW
                .cbSize:        resd 1
                .style:         resd 1
                .lpfnWndProc:   resq 1
                .cbClsExtra:    resd 1
                .cbWndExtra:    resd 1
                .hInstance:     resq 1
                .hIcon:         resq 1
                .hCursor:       resq 1
                .hbrBackground: resq 1
                .lpszMenuName:  resq 1
                .lpszClassName: resq 1
                .hIconSm:       resq 1
        endstruc

        %define BI_RGB 0

        %define CW_USEDEFAULT 80000000h

        %define DIB_RGB_COLORS 0

        %define PM_REMOVE 0001h

        %define SRCCOPY 00CC0020h

        %define SW_SHOWNORMAL 1

        %define WM_CLOSE   0010h
        %define WM_DESTROY 0002h
        %define WM_SIZE    0005h

        %define WS_CAPTION     00C00000h
        %define WS_MAXIMIZEBOX 00010000h
        %define WS_MINIMIZEBOX 00020000h
        %define WS_OVERLAPPED  00000000h
        %define WS_SYSMENU     00080000h
        %define WS_THICKFRAME  00040000h

        %define WS_OVERLAPPEDWINDOW (WS_CAPTION | WS_MAXIMIZEBOX | WS_MINIMIZEBOX | \
                WS_OVERLAPPED | WS_SYSMENU | WS_THICKFRAME)
        %define PONG_STYLE WS_OVERLAPPEDWINDOW
