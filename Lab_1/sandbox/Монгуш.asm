; FASM, Linux x86, 32 бита, UTF-8
format ELF
public _start
section '.data' writeable
    message db 'Монгуш', 10
            db 'Темир', 10
            db 'Мергенович', 10
    message_length = $ - message
section '.text' executable
_start:
    ; write(1, message, message_length)
    mov eax, 4              ; системный вызов write
    mov ebx, 1              ; стандартный вывод
    mov ecx, message        ; адрес текста
    mov edx, message_length ; длина текста в байтах
    int 0x80
    ; exit(0)
    mov eax, 1              ; системный вызов exit
    mov ebx, 0              ; успешное завершение
    int 0x80
