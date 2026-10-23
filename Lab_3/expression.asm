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
include 'common.inc'
