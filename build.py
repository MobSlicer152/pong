#!/usr/bin/env python

import os
import subprocess
import argparse


def assemble(source_dir, obj_dir, asm, asm_flags, inc):
    inc = ["-I" + path for path in inc.split()]
    for root, _, files in os.walk(source_dir):
        for filename in files:
            if filename.endswith(".asm"):
                source_file = os.path.join(root, filename)
                obj_file = os.path.join(obj_dir, os.path.splitext(filename)[0] + ".obj")

                # Check if obj_file exists and its modification time is newer than source_file
                if not os.path.exists(obj_file) or os.path.getmtime(
                    obj_file
                ) < os.path.getmtime(source_file):
                    print(f"Assembling {source_file} into {obj_file}")
                    subprocess.run(
                        asm.split()
                        + inc
                        + asm_flags.split()
                        + [source_file, "-o", obj_file],
                        check=True,
                    )

                    if not os.path.exists(obj_file):
                        print(f"Failed to assemble {source_file}, stopping build")
                        exit(1)
                else:
                    print(f"Skipping {source_file}, object file up to date.")


def link(obj_dir, binary, linker, link_flags, lib_dirs, libs):
    obj_files = [
        os.path.join(obj_dir, f) for f in os.listdir(obj_dir) if f.endswith(".obj")
    ]
    lib_dirs = ["/libpath:" + path for path in lib_dirs.split()]
    print(f"Linking {binary} from files in {obj_dir}")
    link_command = (
        linker.split()
        + link_flags.split()
        + lib_dirs
        + ["/out:" + binary]
        + obj_files
        + [libs]
    )
    subprocess.run(link_command, check=True)


def get_linker():
    if os.name == "nt":
        return "link /nologo"
    else:
        return "lld-link"


def clean_directory(directory):
    for filename in os.listdir(directory):
        file_path = os.path.join(directory, filename)
        try:
            if os.path.isfile(file_path):
                os.remove(file_path)
        except Exception as e:
            print(f"Error cleaning {file_path}: {e}")


def main():
    root = os.path.abspath(os.path.dirname(__file__))
    inc = os.path.join(root, "inc")
    source = os.path.join(root, "source")
    obj = os.path.join(root, "obj")

    parser = argparse.ArgumentParser(
        description="Build assembly code using specified tools."
    )
    parser.add_argument(
        "--asm", default="nasm", help="Path to the assembler (default: nasm)"
    )
    parser.add_argument(
        "--linker",
        default=get_linker(),
        help=f"Path to the linker (default: {get_linker()})",
    )
    parser.add_argument(
        "--asm_flags",
        default="-fwin64 -g",
        help="Assembler flags (default: -fwin64 -g)",
    )
    parser.add_argument(
        "--out",
        default=os.path.join(root, "out"),
        help="Output directory for the binary",
    )
    parser.add_argument(
        "--binary",
        default="pong.exe",
        help="Name of the output binary (default: pong.exe)",
    )
    parser.add_argument(
        "--link_flags",
        default="/nodefaultlib /subsystem:console /debug",
        help="Linker flags (default: /nodefaultlib /subsystem:console /debug)",
    )
    parser.add_argument(
        "--lib_dirs",
        default=os.path.join(root, "lib"),
        help="Library search directories (default: lib)",
    )
    parser.add_argument(
        "--libs", default="ntdll.lib", help="Library dependencies (default: ntdll.lib)"
    )
    parser.add_argument(
        "--clean",
        action="store_true",
        help="Clean object files in the 'obj' directory before building",
    )

    args = parser.parse_args()

    # Ensure output directories exist
    os.makedirs(obj, exist_ok=True)
    os.makedirs(args.out, exist_ok=True)

    # Clean object files if --clean is passed
    if args.clean:
        print("Cleaning object files...")
        clean_directory(obj)

    # Assemble source files
    assemble(source, obj, args.asm, args.asm_flags, inc)

    # Link the binary
    binary_path = os.path.join(args.out, args.binary)
    link(obj, binary_path, args.linker, args.link_flags, args.lib_dirs, args.libs)


if __name__ == "__main__":
    main()
