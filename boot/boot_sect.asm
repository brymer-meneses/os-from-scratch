; This instruction adds an offset to each label we call.
; This is essential since this is where the start of our program is located in.
[bits 16]
[org 0x7c00]
KERNEL_OFFSET equ 0x1000

mov [BOOT_DRIVE], dl

mov bp, 0x9000
mov sp, bp

mov bx, MSG_REAL_MODE
call print_string

call load_kernel

call switch_to_pm

jmp $

; imports
%include "boot/print/print_string.asm"
%include "boot/disk/disk_load.asm"
%include "boot/pm/gdt.asm"
%include "boot/pm/print_string_pm.asm"
%include "boot/pm/switch_to_pm.asm"

[bits 16]

load_kernel:
  mov bx, MSG_LOAD_KERNEL
  call print_string

  mov bx, KERNEL_OFFSET
  mov dh, 15
  mov dl, [BOOT_DRIVE]
  call disk_load
  ret

[bits 32]
BEGIN_PM:
  mov ebx, MSG_PROT_MODE
  call print_string_pm
  call KERNEL_OFFSET

  jmp $

BOOT_DRIVE      db 0
MSG_REAL_MODE   db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE   db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory.", 0

; A bootsector must have exactly 512 bytes, and it must have the `0xaa55` magic
; number at the end of it. Therefore we need to add zero padding to make sure
; it abides by this criteria. `($ - $$)` calculates the difference between the
; location counter `$` or offset being assembled, while `$$` refers to the
; start address or offset of the current section
times 510 - ($-$$) db 0

; Last two bytes (one word) form the magic number, which tells the BIOS
; that this program is a boot sector.
dw 0xaa55

; ; 15 sector padding
; times 15*256 dw 0xDADA
