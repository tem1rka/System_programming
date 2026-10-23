; Сумма 1+2-3-4+5+6-7-8+...; 0 <= n <= 1000000000.
format ELF64
public _start
section '.text' executable
_start:
    call read_uint
    cmp rax, 1000000000
    ja error
    mov r12, rax
    xor r13d, r13d                  ; сумма
    mov ebx, 1
.loop:
    cmp rbx, r12
    ja .done
    mov rax, rbx
    dec rax
    test rax, 2                     ; знаки +,+,-,-
    jz .plus
    sub r13, rbx
    jmp .next
.plus:
    add r13, rbx
.next:
    inc rbx
    jmp .loop
.done:
    mov rax, r13
    call print_int
    jmp exit
include 'common.inc'
