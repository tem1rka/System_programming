; Число — непрерывная последовательность цифр 0..9; по одному на строку.
; ./task9 input.txt new_numbers.txt
format ELF64
public _start
section '.text' executable
_start:
    cmp qword [rsp], 3
    jne error
    mov rdi, [rsp+16]
    call open_read
    mov r12, rax
    mov rdi, [rsp+24]
    call open_output
    mov r13, rax
    xor ebx, ebx                    ; внутри числа = 1
.loop:
    mov rdi, r12
    call read_byte
    test rax, rax
    jz .done
    cmp byte [symbol], '0'
    jb .separator
    cmp byte [symbol], '9'
    ja .separator
    mov rdi, r13
    call write_byte
    mov ebx, 1
    jmp .loop
.separator:
    test ebx, ebx
    jz .loop
    mov byte [symbol], 10
    mov rdi, r13
    call write_byte
    xor ebx, ebx
    jmp .loop
.done:
    test ebx, ebx
    jz .close
    mov byte [symbol], 10
    mov rdi, r13
    call write_byte
.close:
    mov rdi, r12
    call close_file
    mov rdi, r13
    call close_file
    jmp exit
include 'file_io.inc'
