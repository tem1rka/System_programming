format ELF64
public _start
section '.data' writable
    source db 'PBREUSjkMUTGFNkuEzpyOMLGeDmEHCFHlF'
    length = $-source
section '.bss' writable
    result rb length+1
section '.text' executable
_start:
    xor ecx, ecx
.reverse:
    mov rbx, length-1
    sub rbx, rcx
    mov al, [source+rbx]
    mov [result+rcx], al
    inc rcx
    cmp rcx, length
    jb .reverse
    mov byte [result+length], 10
    mov eax, 1
    mov edi, 1
    mov rsi, result
    mov edx, length+1
    syscall
    mov eax, 60
    xor edi, edi
    syscall
