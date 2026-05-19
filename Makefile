NASM = .\Tools\nasm-3.01\nasm.exe
QEMU = .\Tools\qemu-i386\qemu.exe
CRTIMG = .\Tools\CrtImg.exe

all: os.img

bootloader.bin: bootloader.asm
	$(NASM) -f bin bootloader.asm -o bootloader.bin
kernal.bin: kernal.asm
	$(NASM) -f bin kernal.asm -o kernal.bin

os.img: bootloader.bin kernal.bin
	$(CRTIMG) len:1440 size:2 bootloader.bin kernal.bin fill:00

run: os.img
	$(QEMU) -fda os.img
	
clean:
	del *.bin
	del *.img
	del *.o