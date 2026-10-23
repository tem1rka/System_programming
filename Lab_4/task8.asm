; Между цифрами и после последней цифры ставится 0. n <= 999999999.
format ELF64
public _start
section '.text' executable
_start:
    call read_uint
    cmp rax, 999999999
    ja error
    mov ebx, 10
    mov r12d, 10                     ; разряд цифры в результате
    xor r13d, r13d
.digit:
    xor edx, edx
    div rbx
    imul rdx, r12
    add r13, rdx
    imul r12, r12, 100
    test rax, rax
    jnz .digit
    mov rax, r13
    call print_int
    jmp exit
include 'common.inc'
