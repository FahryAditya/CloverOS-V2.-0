#!/bin/bash
# build.sh - Build ZaqiOS OS image

# Tools
ASM=nasm
CC=i686-elf-g++
LD=i686-elf-ld
CFLAGS="-ffreestanding -m32 -O2 -Wall -Wextra"
LDFLAGS="-T linker.ld -m elf_i386"

# Files
BOOTLOADER=bootloader.asm
KERNEL_ENTRY=kernel_entry.asm
KERNEL_CPP=kernel.cpp
KERNEL_BIN=kernel.bin
OS_BIN=os-image.bin
OS_ISO=os.iso

# Clean previous build
rm -f *.o *.bin *.iso

echo "Assembling bootloader..."
$ASM -f bin $BOOTLOADER -o bootloader.bin

echo "Assembling kernel entry..."
$ASM -f elf32 $KERNEL_ENTRY -o kernel_entry.o

echo "Compiling kernel C++..."
$CC $CFLAGS -c $KERNEL_CPP -o kernel.o

echo "Linking kernel..."
$LD $LDFLAGS kernel_entry.o kernel.o -o $KERNEL_BIN

echo "Creating OS image..."
cat bootloader.bin $KERNEL_BIN > $OS_BIN

echo "Creating bootable ISO..."
genisoimage -o $OS_ISO -b bootloader.bin -no-emul-boot -boot-load-size 4 -boot-info-table .

echo "Build complete!"
echo "Run OS in QEMU: qemu-system-i386 -fda $OS_BIN"
