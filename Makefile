NASM = .\Tools\nasm-3.01\nasm.exe
QEMU = .\Tools\qemu-i386\qemu.exe
CRTIMG = .\Tools\CrtImg.exe
LD = ld.exe
GCC = gcc.exe
OBJCOPY = objcopy.exe

all: os.img

bootloader.bin: bootloader.asm
	$(NASM) -f bin bootloader.asm -o bootloader.bin

kernel.o: kernel.c
	$(GCC) -m32 -ffreestanding -c kernel.c -o kernel.o -nostdlib
font.o: font.c
	$(GCC) -m32 -ffreestanding -c font.c -o font.o -nostdlib

kernel.bin: kernel.asm asmfunc.asm kernel.o font.o
	$(NASM) -f elf32 kernel.asm -o kernel_asm.o
	$(NASM) -f elf32 asmfunc.asm -o func_asm.o

	$(LD) -Ttext 0x8000 -o kernel.elf kernel_asm.o func_asm.o kernel.o font.o
	$(OBJCOPY) -O binary kernel.elf kernel.bin

os.img: bootloader.bin kernel.bin
	$(CRTIMG) len:1440 size:2 bootloader.bin kernel.bin fill:00

run: os.img
	$(QEMU) -fda os.img -vga std -d int,cpu_reset -D qemu.log
	
clean:
	del *.bin
	del *.img
	del *.o
	del *.elf