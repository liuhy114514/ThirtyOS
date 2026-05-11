NASM = ..\Tools\nasm-3.01\nasm.exe
QEMU = ..\Tools\qemu-i386\qemu.exe

all: bootloader.bin

bootloader.bin: bootloader.asm
	$(NASM) -f bin bootloader.asm -o bootloader.bin

run: bootloader.bin
	$(QEMU) -fda bootloader.bin
	
clean:
	del *.bin
	del *.img