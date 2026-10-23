format ELF64 executable 3
entry _start
segment readable executable

_start:
    mov rax, 2269503710
    mov ebx, 10
    xor r8d, r8d
.sum:
    xor edx, edx
    div rbx
    add r8, rdx
    test rax, rax
    jnz .sum
    mov rax, r8
    mov rsi, buffer+31
    mov byte [rsi], 10
    mov ecx, 1
.decimal:
    xor edx, edx
    div rbx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    inc rcx
    test rax, rax
    jnz .decimal
    mov rdx, rcx
    mov eax, 1
    mov edi, 1
    syscall
    mov eax, 60
    xor edi, edi
    syscall

segment readable writeable
buffer rb 32
