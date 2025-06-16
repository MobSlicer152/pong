@echo off

setlocal

set "OBJ=%~dp0obj"
set "OUT=%~dp0out"

set FLAGS=-I"%~dp0."
set AFLAGS=%FLAGS% -fwin32 -g
set CFLAGS=%FLAGS% -nologo -Zi -Zl

if not exist %OBJ% mkdir %OBJ%
if not exist %OUT% mkdir %OUT%

pushd %OBJ%
cl %CFLAGS% -c -Fo"%OBJ%\test.obj" "%~dp0test.c"
nasm %AFLAGS% -o "%OBJ%\main.obj" "%~dp0main.asm"
nasm %AFLAGS% -o "%OBJ%\window.obj" "%~dp0window.asm"
popd
link -nologo -debug -subsystem:WINDOWS -out:"%OUT%\pong.exe" %OBJ%\*.obj user32.lib kernel32.lib
