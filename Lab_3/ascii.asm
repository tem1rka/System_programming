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
include 'common.inc'
