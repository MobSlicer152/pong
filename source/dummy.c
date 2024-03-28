#include <windows.h>

int   WINAPI StretchDIBits2(_In_ HDC hdc, _In_ int xDest, _In_ int yDest, _In_ int DestWidth, _In_ int DestHeight, _In_ int xSrc, _In_ int ySrc, _In_ int SrcWidth, _In_ int SrcHeight,
    _In_opt_ CONST VOID* lpBits, _In_ CONST BITMAPINFO* lpbmi, _In_ UINT iUsage, _In_ DWORD rop)
{
    return StretchDIBits(hdc, xDest, yDest, DestWidth, DestHeight, xSrc, ySrc, SrcWidth, SrcHeight, lpBits, lpbmi, iUsage, rop);
}