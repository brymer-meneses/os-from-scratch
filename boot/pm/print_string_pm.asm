;
; A routine for printing a null-terminated string directy to video memory in
; protected mode
; 

[bits 32]

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null-terminated string pointed to by EDX
print_string_pm:
  pusha
  mov edx, VIDEO_MEMORY       ; Set edx to the start of video memory

print_string_pm_loop:
  mov al, [ebx]
  mov ah, WHITE_ON_BLACK      ; Store the char at EBX in AL

  cmp al, 0                   ; if the current character al is the null
                              ; termination, then end this process
  je print_string_pm_done

  mov [edx], ax               ; Store char and attributes at current character cell

  inc ebx                     ; Increment EBX to the next char in string
  add edx, 2                  ; Move to the next character cell in video memory

  jmp print_string_pm_loop

print_string_pm_done:
  popa
  ret
