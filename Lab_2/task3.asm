format ELF64
public _start
N = 435
M = 15
K = 29
section '.data' writable
    newline db 10
section '.bss' writable
    symbols rb N
section '.text' executable
_start:
    cld
    mov rdi, symbols
    mov ecx, N
    mov al, '!'
    rep stosb
    mov r12, symbols
    mov r13d, 1
.row:
    mov eax, 1
    mov edi, 1
    mov rsi, r12
    mov rdx, r13
    syscall
    add r12, r13
    mov eax, 1
    mov edi, 1
    mov rsi, newline
    mov edx, 1
    syscall
    inc r13
    cmp r13, K
    jbe .row
    mov eax, 60
    xor edi, edi
    syscall
