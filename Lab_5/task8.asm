; Общие символы без повторов, по возрастанию ASCII-кода.
; ./task8 first.txt second.txt new_result.txt
format ELF64
public _start
section '.bss' writable
    seen rb 256
    common rb 256
section '.text' executable
_start:
    cmp qword [rsp], 4
    jne error
    mov rdi, [rsp+16]
    call open_read
    mov r12, rax
.first:
    mov rdi, r12
    call read_byte
    test rax, rax
    jz .second_file
    movzx eax, byte [symbol]
    mov byte [seen+rax], 1
    jmp .first
.second_file:
    mov rdi, r12
    call close_file
    mov rdi, [rsp+24]
    call open_read
    mov r12, rax
.second:
    mov rdi, r12
    call read_byte
    test rax, rax
    jz .output
    movzx eax, byte [symbol]
    mov dl, [seen+rax]
    mov [common+rax], dl
    jmp .second
.output:
    mov rdi, r12
    call close_file
    mov rdi, [rsp+32]
    call open_output
    mov r12, rax
    xor ebx, ebx
.write:
    cmp byte [common+rbx], 0
    je .next
    mov [symbol], bl
    mov rdi, r12
    call write_byte
.next:
    inc ebx
    cmp ebx, 256
    jb .write
    mov rdi, r12
    call close_file
    jmp exit
include 'file_io.inc'
