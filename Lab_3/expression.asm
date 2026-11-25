; Вариант 11: ((((c/b)+a)/c)+a). Целочисленное деление.
format ELF64
public _start
section '.text' executable
_start:
    cmp qword [rsp], 4
    jne error
    mov rsi, [rsp+16]
    call parse_int
    mov r12, rax                     ; a
    mov rsi, [rsp+24]
    call parse_int
    mov r13, rax                     ; b
    mov rsi, [rsp+32]
    call parse_int
    mov r14, rax                     ; c
    test r13, r13
    jz error
    test r14, r14
    jz error
    mov rax, r14
    mov rbx, r13
    call divide
    add rax, r12
    jo error
    mov rbx, r14
    call divide
    add rax, r12
    jo error
    call print_int
    jmp exit
divide:
    mov rdx, 8000000000000000h
    cmp rax, rdx
    jne .ok
    cmp rbx, -1
    je error
.ok:
    cqo
    idiv rbx
    ret

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
