
BUILD_DIR := build
QEMU := qemu-system-x86_64

BOOT_SOURCES := $(wildcard boot/*.asm)

bootloader: $(BOOT_SOURCES)
	mkdir -p build
	nasm boot/boot_sect.asm -f bin -o build/boot_sect.bin

# for some reason we need to do this
# https://stackoverflow.com/questions/34216893/disk-read-error-while-loading-sectors-into-memory

	dd if=/dev/zero of=build/disk.img bs=1024 count=1440
	dd if=build/boot_sect.bin of=build/disk.img conv=notrunc

clean:
	$(RM) -rf build
	
run: build
	$(QEMU) -drive format=raw,file=build/disk.img

