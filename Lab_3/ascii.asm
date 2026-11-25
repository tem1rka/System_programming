format ELF64
public _start
section '.text' executable
_start:
    cmp qword [rsp], 2
    jne error
    mov rsi, [rsp+16]
    cmp byte [rsi], 0
    je error
    cmp byte [rsi+1], 0
    jne error
    movzx eax, byte [rsi]
    cmp eax, 127
    ja error
    call print_int
    jmp exit

; print_int: вывести int64 из rax и перевод строки через write.
print_int:
    xor r10d, r10d
    test rax, rax
    jns .convert
    inc r10d
    neg rax
.convert:
    mov r8d, 10
    mov rsi, number_buffer+31
    mov byte [rsi], 10
    mov edx, 1
.loop:
    push rdx
    xor edx, edx
    div r8
    add dl, '0'
    dec rsi
    mov [rsi], dl
    pop rdx
    inc rdx
    test rax, rax
    jnz .loop
    test r10d, r10d
    jz .write
    dec rsi
    mov byte [rsi], '-'
    inc rdx
.write:
    mov edi, 1
    mov eax, 1
    syscall
    ret

exit:
    mov eax, 60
    xor edi, edi
    syscall
error:
    mov eax, 1
    mov edi, 2
    mov rsi, error_message
    mov edx, error_length
    syscall
    mov eax, 60
    mov edi, 1
    syscall

section '.data' writable
error_message db 'Invalid input or I/O error',10
error_length = $-error_message
section '.bss' writable
number_buffer rb 32
