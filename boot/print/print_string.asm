
; arg0: bx - pointer to string to be printed
print_string:
  pusha
  mov ah, 0x0e ; BIOS teletype mode

  loop:
    mov al, [bx] ; read the current character in the string bx
    int 0x10     ; interrupt

    inc bx       ; incrementing bx will point it to the next character in the
                 ; string

    cmp al, 0    ; check if the current character is the null termination
    jne loop     ; if so, end the loop

  popa
  ret
