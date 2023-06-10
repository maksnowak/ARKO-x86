; ==========================================================================================
; 20. char *smul(char *d, char *s1, char *s2);
; Mnożenie długich całkowitych liczb dziesiętnych bez znaku, zapisanych jako łańcuchy cyfr,
; z wynikiem w takiej samej postaci- Program główny powinien zaalokować bufor na łańcuch
; wynikowy. W wersji 32-bitowej wskazane zastosowanie instrukcji AAM.
; ==========================================================================================

; rdi - bufor na łańcuch wynikowy
; rsi - pierwsza liczba
; rdx - druga liczba
; rbx - kopia łańcucha wynikowego
; r10 - długosc pierwszej liczby
; r11 - długosc drugiej liczby
; r12 - rejestr pomocniczy
; r13 - przechowuje wartość 10
; r14 - iterator mnożnej
; r15 - iterator mnożnika

    section .text
    global smul
; Prolog
smul:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    xor rax, rax
    mov r13, 10
convert_first:
    xor r10, r10
first_loop:
    mov al, [rsi + r10]
    sub al, '0'
    xchg al, [rsi + r10]
    inc r10
    test al, al
    jnz first_loop
    dec r10
convert_second:
    xor r11, r11
second_loop:
    mov al, [rdx + r11]
    sub al, '0'
    xchg al, [rdx + r11]
    inc r11
    test al, al
    jnz second_loop
    dec r11
multiply:
    mov rbx, rsi
    add rbx, r10
    inc rbx
    add rsi, r10
    mov r14, 0
    mov r15, 0
multiplicand:
    inc r14
    add rbx, r11
    dec rbx
    dec rdx
    mov r12b, [rsi]
    add rdx, r11
multiplier:
    inc r15
    dec rbx
    dec rdx
    mov al, [rdx]
    mul r12b
    add al, [rbx]
    div r13b
    xchg al, ah
    add [rbx-1], ah
    mov [rbx], al
    cmp r15, r11
    jne multiplier
    cmp r14, r10
    jne multiplicand
remove_zeros:
    mov rax, rdi
    mov r12b, [rax]
    test r12b, r12b
    jnz done
    inc rax
    dec r11

    mov r12b, [rax]
    test r12b, r12b
    jnz done
    dec rax
    add byte [rax], '0'
    jmp fin
done:
    mov rbx, rax
    add rbx, r10
    add rbx, r11
convert_ascii:
    dec rbx
    add byte [rbx], '0'
    cmp rbx, rax
    jg convert_ascii
fin:
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
