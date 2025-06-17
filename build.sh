#!/usr/bin/env bash

ROOT="$(realpath $(dirname $0))"
OBJ="$ROOT/obj"
OUT="$ROOT/out"

FLAGS="-I\"$ROOT\""
AFLAGS="$FLAGS -fwin32 -g"
CFLAGS="$FLAGS -m32 -nologo -Zi -Zl"
LDFLAGS="-debug -nologo -debug -subsystem:windows -libpath:$ROOT/libs"
LIBS="user32.lib kernel32.lib"

if [ ! -d $OBJ ]; then mkdir $OBJ; fi
if [ ! -d $OUT ]; then mkdir $OUT; fi

clang-cl $CFLAGS -c -Fo"$OBJ/test.obj" "$ROOT/test.c"
nasm $AFLAGS -o "$OBJ/main.obj" "$ROOT/main.asm"
nasm $AFLAGS -o "$OBJ/window.obj" "$ROOT/window.asm"

lld-link $LDFLAGS -out:"$OUT/pong.exe" $(find $OBJ -type f -iregex "^.*\.obj$") $LIBS

