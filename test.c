typedef struct {
    int cbSize;
    int style;
    void (*lpfnWndProc)();
    int cbClsExtra;
    int cbWndExtra;
    int hInstance;
    int hIcon;
    int hCursor;
    int hbrBackground;
    int lpszMenuName;
    int lpszClassName;
    int hIconSm;
} WNDCLASSEXA;

#if 0
int __stdcall CreateWindowExA(int exStyle, const char* className, const char* title, int style, int x, int y, int width, int height, int parent, int menu, void* instance, void* param)
{
    return 0;
}
#endif
