
QEMU	:= qemu-system-x86_64
LD		:= x86_64-elf-ld
CC		:= x86_64-elf-gcc
OBJCOPY := x86_64-elf-objcopy

BUILD_DIR := build
RUST_DIR  := kernel
RUST_FILES := $(wildcard $(RUST_DIR)/**/*.rs $(RUST_DIR)/*.rs)

CARGO_FLAGS := --release --target-dir=$(abspath $(BUILD_DIR))

BOOT_LOADER_SOURCES := $(wildcard boot/*.asm)

.PHONY: run clean

all: $(BUILD_DIR)/disk.img

# Create the disk image by combining boot sector and kernel
$(BUILD_DIR)/disk.img: $(BUILD_DIR)/boot_sect.bin $(BUILD_DIR)/kernel.bin
	cat $^ > $(BUILD_DIR)/output
	@dd if=/dev/zero of=$@ bs=1024 count=1440
	@dd if=$(BUILD_DIR)/output of=$@ conv=notrunc

# Link kernel objects into a binary kernel file
$(BUILD_DIR)/kernel.bin: $(BUILD_DIR)/kernel_entry.o $(BUILD_DIR)/kernel.a
	$(LD) -o $@ -Ttext 0x1000 $^ --oformat binary

# Compile Rust Kernel
$(BUILD_DIR)/kernel.a: $(RUST_FILES)
	cd kernel && cargo build $(CARGO_FLAGS)
	mv $(BUILD_DIR)/x86_64-unknown-linux-gnu/release/libkernel.a $(BUILD_DIR)/kernel.a

# Assembly boot sector bode
$(BUILD_DIR)/boot_sect.bin: $(BOOT_LOADER_SOURCES) 
	mkdir -p $(BUILD_DIR)
	nasm $< -f bin -o $@

# Assembly kernel entry code
$(BUILD_DIR)/kernel_entry.o: kernel/kernel_entry.asm
	mkdir -p $(BUILD_DIR)
	nasm $< -f elf64 -o $@

# Run the emulator with the disk image
run: $(BUILD_DIR)/disk.img
	$(QEMU) -drive format=raw,file=$<

# Clean the build directory
clean:
	$(RM) -rf build
