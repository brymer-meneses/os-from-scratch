
gdt_start:

gdt_null:
  dd 0x0
  dd 0x0

; the code segment descriptor
; base=0x0
; limit=0xfffff
; 1st flags: 
;   (present) - 1
;   (privilege) - 00
;   (descriptor type) - 1
;   -> 1001b
; type flags:
;   (code) - 1
;   (conforming) - 0
;   (readable) - 1
;   (accessed) - 0
;   -> 1010b
; 2nd flags:
;   (granularity) - 1
;   (32-bit default) - 1
;   (64-bit seg) - 0
;   (AVL) - 0
;   -> 1100b
gdt_code:
  dw 0xffff
  dw 0x0
  db 0x0
  db 10011010b
  db 11001111b
  db 0x0

; the data segment descriptor
; type flags:
;   (code) - 0
;   (expand down) - 0
;   (writable) - 1
;   (accessed) - 0
;   -> 0010b
gdt_data:
  dw 0xffff
  dw 0x0
  db 0x0
  db 10010010b
  db 11001111b
  db 0x0

gdt_end:

gdt_descriptor:
  dw gdt_end - gdt_start - 1    ; Size of the GDT, always less one of the true size
  dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start


