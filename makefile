
QEMU	:= qemu-system-x86_64
LD		:= i686-elf-ld
CC		:= i686-elf-gcc

BUILD_DIR := build

BOOT_LOADER_SOURCES := $(wildcard boot/*.asm)
KERNEL_SOURCES  	:= $(shell ls -R kernel | grep -E "\.(c)")
KERNEL_OBJECTS := $(addprefix $(BUILD_DIR)/, $(KERNEL_SOURCES:.c=.o))

.PHONY: run clean

all: $(BUILD_DIR)/disk.img

# Create the disk image by combining boot sector and kernel
$(BUILD_DIR)/disk.img: $(BUILD_DIR)/boot_sect.bin $(BUILD_DIR)/kernel.bin
	cat $^ > $(BUILD_DIR)/output
	@dd if=/dev/zero of=$@ bs=1024 count=1440
	@dd if=$(BUILD_DIR)/output of=$@ conv=notrunc

# Link kernel objects into a binary kernel file
$(BUILD_DIR)/kernel.bin: $(BUILD_DIR)/kernel_entry.o $(KERNEL_OBJECTS) 
	$(LD) -o $@ -Ttext 0x1000 $^ --oformat binary

# Compile C source files into object files
$(BUILD_DIR)/%.o: kernel/%.c
	$(CC) -ffreestanding -c $< -o $@

# Assembly boot sector bode
$(BUILD_DIR)/boot_sect.bin: $(BOOT_LOADER_SOURCES) 
	mkdir -p $(BUILD_DIR)
	nasm $< -f bin -o $@

# Assembly kernel entry code
$(BUILD_DIR)/kernel_entry.o: kernel/kernel_entry.asm
	mkdir -p $(BUILD_DIR)
	nasm $< -f elf -o $@

# Run the emulator with the disk image
run: $(BUILD_DIR)/disk.img
	$(QEMU) -drive format=raw,file=$<

# Clean the build directory
clean:
	$(RM) -rf build
