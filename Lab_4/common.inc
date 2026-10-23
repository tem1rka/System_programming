; Linux x86-64. Вспомогательные процедуры по образцу func.asm из лекций.
; rbx, rbp, r12-r15 сохраняются; остальные регистры могут изменяться.
; parse_uint: rsi -> строка, rax <- число; строгая проверка uint64.
parse_uint:
    xor eax, eax
    mov r8d, 10
    cmp byte [rsi], 0
    je error
.loop:
    movzx r9d, byte [rsi]
    test r9b, r9b
    jz .done
    sub r9d, '0'
    cmp r9d, 9
    ja error
    mul r8
    test rdx, rdx
    jnz error
    add rax, r9
    jc error
    inc rsi
    jmp .loop
.done:
    ret

; parse_int: rsi -> строка, rax <- int64.
parse_int:
    xor r10d, r10d
    cmp byte [rsi], '-'
    jne .positive
    inc rsi
    inc r10d
    jmp .convert
.positive:
    cmp byte [rsi], '+'
    jne .convert
    inc rsi
.convert:
    call parse_uint
    mov r9, 7FFFFFFFFFFFFFFFh
    add r9, r10
    cmp rax, r9
    ja error
    test r10d, r10d
    jz .done
    neg rax
.done:
    ret

; read_uint: ввод одной строки через read(0,...), результат в rax.
read_uint:
    xor r10d, r10d
.loop:
    xor eax, eax
    xor edi, edi
    lea rsi, [input_buffer+r10]
    mov edx, 1
    syscall
    test rax, rax
    js error
    jz .done
    cmp byte [rsi], 10
    je .done
    inc r10
    cmp r10, 31
    jae error
    jmp .loop
.done:
    mov byte [input_buffer+r10], 0
    mov rsi, input_buffer
    jmp parse_uint

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
input_buffer rb 32
number_buffer rb 32
