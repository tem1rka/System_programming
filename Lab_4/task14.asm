; Автоморфные числа: k*k mod 10^(число цифр k) = k. n <= 1000000.
format ELF64
public _start
section '.text' executable
_start:
    call read_uint
    cmp rax, 1000000
    ja error
    mov r12, rax
    mov ebx, 1
    mov r13d, 10
.loop:
    cmp rbx, r12
    ja exit
    cmp rbx, r13
    jb .square
    imul r13, r13, 10
.square:
    mov rax, rbx
    imul rax, rbx
    xor edx, edx
    div r13
    cmp rdx, rbx
    jne .next
    mov rax, rbx
    call print_int
.next:
    inc rbx
    jmp .loop
include 'common.inc'
