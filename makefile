
QEMU 						:= qemu-system-x86_64
LD							:= i686-elf-ld
CC							:= i686-elf-gcc

BUILD_DIR 			:= build
BOOT_SOURCES 		:= $(wildcard boot/*.asm)
KERNEL_SOURCES  := $(wildcard kernel/*.c) $(wildcard kernel/*.asm)

.PHONY: kernel build

all: bootloader kernel image

bootloader: $(BOOT_SOURCES)
	mkdir -p build
	nasm boot/boot_sect.asm -f bin -o build/boot_sect.bin

kernel: $(KERNEL_SOURCES) bootloader
	$(CC) -ffreestanding -c kernel/kernel.c -o build/kernel.o
	nasm kernel/kernel_entry.asm -f elf -o build/kernel_entry.o
	$(LD) -o build/kernel.bin -Ttext 0x1000 build/kernel_entry.o build/kernel.o --oformat binary

image: kernel
	cat build/boot_sect.bin build/kernel.bin > build/os-image
# for some reason we need to do this
# https://stackoverflow.com/questions/34216893/disk-read-error-while-loading-sectors-into-memory
	dd if=/dev/zero of=build/disk.img bs=1024 count=1440
	dd if=build/os-image of=build/disk.img conv=notrunc

run: image
	$(QEMU) -drive format=raw,file=build/disk.img

clean:
	$(RM) -rf build
