; This instruction adds an offset to each label we call.
; This is essential since this is where the start of our program is located in.
[bits 16]
[org 0x7c00]

mov [BOOT_DRIVE], dl

mov bp, 0x8000
mov sp, bp

mov bx, 0x9000
mov dh, 5
mov dl, [BOOT_DRIVE]
call disk_load

mov dx, [0x9000]
call print_hex

mov dx, [0x9000 + 512]
call print_hex

jmp $


; imports
%include "boot/print_string.asm"
%include "boot/print_hex.asm"
%include "boot/disk_load.asm"

BOOT_DRIVE: db 0

; A bootsector must have exactly 512 bytes, and it must have the `0xaa55` magic
; number at the end of it. Therefore we need to add zero padding to make sure
; it abides by this criteria. `($ - $$)` calculates the difference between the
; location counter `$` or offset being assembled, while `$$` refers to the
; start address or offset of the current section
times 510 - ($-$$) db 0

; Last two bytes (one word) form the magic number, which tells the BIOS
; that this program is a boot sector.
dw 0xaa55

times 256 dw 0xdada
times 256 dw 0xface
