; rdi = имя. Возвращает дескриптор в rax.
open_read:
    xor esi, esi
    mov eax, 2
    syscall
    test rax, rax
    js error
    ret
; O_EXCL: выходной файл должен быть новым, чтобы не затереть входной.
open_output:
    mov esi, 193                    ; O_WRONLY|O_CREAT|O_EXCL
    mov edx, 644o
    mov eax, 2
    syscall
    test rax, rax
    js error
    ret
; rdi = fd. Возвращает rax=1/0, байт в symbol.
read_byte:
    xor eax, eax
    mov rsi, symbol
    mov edx, 1
    syscall
    cmp rax, -4                      ; EINTR
    je read_byte
    test rax, rax
    js error
    ret
; rdi = fd, byte [symbol] = символ.
write_byte:
    mov eax, 1
    mov rsi, symbol
    mov edx, 1
    syscall
    cmp rax, -4
    je write_byte
    cmp rax, 1
    jne error
    ret
close_file:
    mov eax, 3
    syscall
    test rax, rax
    js error
    ret
exit:
    mov eax, 60
    xor edi, edi
    syscall
error:
    mov eax, 1
    mov edi, 2
    mov rsi, message
    mov edx, message_size
    syscall
    mov eax, 60
    mov edi, 1
    syscall
section '.data' writable
message db 'I/O error: check input names; output must not exist',10
message_size = $-message
section '.bss' writable
symbol rb 1
