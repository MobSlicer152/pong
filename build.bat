@echo off

setlocal

set "ASM=nasm.exe"
set "LINKER=link.exe"
set "ASMFLAGS=-fwin64"
set "LINKFLAGS=/nodefaultlib /subsystem:console"
set "LIBS=ntdll.lib"
set "INC=-I%~dp0inc"
set "SOURCE=%~dp0source"
set "OBJ=%~dp0obj"
set "OUT=%~dp0out"
set "BINARY=%OUT%\pong.exe"

echo Ensuring output directories exist
if not exist %OBJ% mkdir %OBJ%
if not exist %OUT% mkdir %OUT%

echo Assembling files in %SOURCE%
for /r %SOURCE% %%x in (*.asm) do (
	echo Assembling %%x
	%ASM% %INC% %ASMFLAGS% "%%x" -o "%%x.obj"
	if not exist "%%x.obj" echo Failed to assemble %%x, stopping build & exit /b
	move "%%x.obj" %OBJ%
)

echo Linking %BINARY% from files in %OBJ%
for /r %OBJ% %%x in (*.obj) do (
	echo Including %%x
	set "OBJS=%OBJS% %%x"
)
%LINKER% %LINKFLAGS% /out:%BINARY% %OBJS% %LIBS%
