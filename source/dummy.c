#include <windows.h>

ATOM
WINAPI
RegisterClassExW2(
    _In_ CONST WNDCLASSEXW *wndclass)
{
    return (ATOM)1;
}

HWND
WINAPI
CreateWindowExW2(
    _In_ DWORD dwExStyle,
    _In_opt_ LPCWSTR lpClassName,
    _In_opt_ LPCWSTR lpWindowName,
    _In_ DWORD dwStyle,
    _In_ int X,
    _In_ int Y,
    _In_ int nWidth,
    _In_ int nHeight,
    _In_opt_ HWND hWndParent,
    _In_opt_ HMENU hMenu,
    _In_opt_ HINSTANCE hInstance,
    _In_opt_ LPVOID lpParam)
{
    return (HWND)1;
}
