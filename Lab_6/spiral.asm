; ЛР 6, вариант 11. FASM, Linux x86-64, ncurses.
format ELF64
public main
extrn initscr
extrn endwin
extrn cbreak
extrn noecho
extrn start_color
extrn init_pair
extrn getmaxx
extrn getmaxy
extrn clear
extrn move
extrn clrtoeol
extrn printw
extrn timeout
extrn getch
extrn mvaddch
extrn refresh
extrn puts

section '.data' writable
    step_x dd 0, 1, 0, -1
    step_y dd 1, 0, -1, 0      ; вниз, вправо, вверх, влево
    delays dd 90, 30, 5
    status db 'j: exit | l: speed | %d ms | pass %d', 0
    error_msg db 'Need a color terminal of at least 40 columns and 5 rows.', 0
    pair dd 1
    pass_number dd 1
    speed dd 0

section '.bss' writable
    window rq 1
    width rd 1
    height rd 1
    x rd 1
    y rd 1
    direction rd 1
    side rd 1                  ; длина текущего отрезка
    left_steps rd 1

section '.text' executable
main:
    push rbp                   ; выравниваем стек перед вызовами C
    call initscr
    mov [window], rax
    call cbreak
    call noecho
    call start_color
    test eax, eax
    js .error

    mov edi, 1
    xor esi, esi               ; COLOR_BLACK — цвет текста
    mov edx, 7                 ; COLOR_WHITE — фон первой пары
    call init_pair
    test eax, eax
    js .error
    mov edi, 2
    xor esi, esi
    mov edx, 3                 ; COLOR_YELLOW — фон второй пары
    call init_pair
    test eax, eax
    js .error

.resize:
    mov rdi, [window]
    call getmaxx
    mov [width], eax
    cmp eax, 40
    jl .error
    mov rdi, [window]
    call getmaxy
    mov [height], eax
    cmp eax, 5
    jl .error
    call clear

.restart:
    mov eax, [width]
    shr eax, 1
    mov [x], eax
    mov eax, [height]           ; строка 0 отведена под управление
    shr eax, 1
    mov [y], eax
    mov [direction], 0
    mov [side], 1
    mov [left_steps], 1

.show_status:
    xor edi, edi
    xor esi, esi
    call move
    call clrtoeol
    mov eax, [speed]
    mov esi, [delays+rax*4]
    mov edx, [pass_number]
    mov rdi, status
    xor eax, eax               ; у printw нет векторных аргументов
    call printw
    mov eax, [speed]
    mov edi, [delays+rax*4]
    call timeout

.frame:
    mov edi, [y]
    mov esi, [x]
    mov edx, [pair]
    shl edx, 8                 ; COLOR_PAIR(pair) для ncurses
    or edx, ' '                ; рисуем пробел с цветным фоном
    call mvaddch
    mov edi, [y]
    mov esi, [x]
    call move                 ; курсор остаётся на цветной клетке
    call refresh
    call getch                ; клавиша или ожидание до следующего кадра
    cmp eax, 'j'
    je .exit
    cmp eax, 'l'
    je .change_speed
    cmp eax, 410              ; KEY_RESIZE
    je .resize

    ; После показа граничной клетки возвращаемся в центр.
    mov eax, [x]
    test eax, eax
    jz .next_pass
    inc eax
    cmp eax, [width]
    je .next_pass
    mov eax, [y]
    cmp eax, 1
    je .next_pass
    inc eax
    cmp eax, [height]
    je .next_pass

    mov eax, [direction]
    mov edx, [step_x+rax*4]
    add [x], edx
    mov edx, [step_y+rax*4]
    add [y], edx
    dec [left_steps]
    jnz .frame
    inc eax
    and eax, 3                ; после последнего направления снова вниз
    mov [direction], eax
    test eax, 1
    jnz .keep_side
    inc [side]                ; после двух поворотов: 1,1,2,2,3,3,...
.keep_side:
    mov eax, [side]
    mov [left_steps], eax
    jmp .frame

.change_speed:
    inc [speed]
    cmp [speed], 3
    jb .show_status
    mov [speed], 0
    jmp .show_status

.next_pass:
    xor [pair], 3             ; 1 -> 2, 2 -> 1
    inc [pass_number]
    jmp .restart

.exit:
    call endwin
    xor eax, eax
    pop rbp
    ret

.error:
    call endwin
    mov rdi, error_msg
    call puts
    mov eax, 1
    pop rbp
    ret
