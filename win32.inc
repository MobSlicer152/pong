%ifndef _WIN32_INC
%define _WIN32_INC

struc WNDCLASSEXA
    .cbSize: resd 1
    .style: resd 1
    .lpfnWndProc: resd 1
    .cbClsExtra: resd 1
    .cbWndExtra: resd 1
    .hInstance: resd 1
    .hIcon: resd 1
    .hCursor: resd 1
    .hbrBackground: resd 1
    .lpszMenuName: resd 1
    .lpszClassName: resd 1
    .hIconSm: resd 1
endstruc

struc MSG
    .hwnd: resd 1
    .message: resd 1
    .wParam: resd 1
    .lParam: resd 1
    .time: resd 1
    .pt: resd 2
    .lPrivate: resd 1
endstruc

%define CW_USEDEFAULT 80000000h

extern _RegisterClassExA@4
extern _CreateWindowExA@48
extern _DefWindowProcA@16
extern _ExitProcess@4
extern _GetModuleHandleA@4
extern _GetLastError@0
extern _LoadCursorA@8
extern _ShowWindow@8
extern _PeekMessageA@20
extern _TranslateMessage@4
extern _DispatchMessageA@4

%endif
