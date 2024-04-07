#include <stdio.h>

#if 0
extern __declspec(dllimport) unsigned int DbgPrint(char* format, ...);

void FillRectangle(int width, int height, int x, int y, int color)
{
    DbgPrint("%d %d %d %d %X", width, height, x, y, color);
}
#endif
