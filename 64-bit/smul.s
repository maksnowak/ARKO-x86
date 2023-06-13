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
; r10 - długosc pierwszego łańcucha
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
    push r15
    xor rax, rax    ; Wyczyść rax
    mov r13, 10
convert_first:
    xor r10, r10    ; Wyczyść rejrestr przechowujący długość łańcucha
first_loop:
    mov al, [rsi + r10] ; Wczytaj n-ty znak łańcucha
    sub al, '0' ; Zamień znak na liczbę
    xchg al, [rsi + r10]    ; Zamień znak z liczbą 
    inc r10
    test al, al ; Sprawdź czy null
    jnz first_loop
    dec r10 ; Zmniejsz długość łańcucha o 1 - ostatni znak to null
convert_second:
    xor r11, r11 ; Wyczyść rejestr przechowujący długość łańcucha
second_loop:
    mov al, [rdx + r11] ; Wczytaj n-ty znak łańcucha
    sub al, '0' ; Zamień znak na liczbę
    xchg al, [rdx + r11]   ; Zamień znak z liczbą
    inc r11
    test al, al ; Sprawdź czy null
    jnz second_loop
    dec r11 ; Zmniejsz długość łańcucha o 1 - ostatni znak to null
multiply:
    xor r14, r14    ; Wyczyść iterator mnożnej
    ; Przygotowanie do wykonania mnożenia pisemnego
    add rdi, r10    ; Przesuń wskaźnik o długość pierwszego łańcucha
    add rsi, r10    ; Przesuń wskaźnik na koniec pierwszego łańcucha
    inc rdi ; Przesuń wskaźnik poza łańcuch wynikowy
multiplicand:
    add rdi, r11    ; Przesuń wskaźnik o długość drugiego łańcucha
    dec rdi ; Przesuń wskaźnik na koniec drugiego łańcucha
    dec rsi ; Przesuń wskaźnik na następną cyfrę mnożnej
    mov r12b, [rsi] ; Wczytaj cyfrę mnożnej
    ; Przejdź na koniec mnożnika
    add rdx, r11    ; Przesuń wskaźnik o długość drugiego łańcucha
    xor r15, r15    ; Wyczyść iterator mnożnika
    inc r14 ; Zwiększ iterator mnożnej
multiplier:
    dec rdi ; Przesuń wskaźnik na wynik
    dec rdx ; Przesuń wskaźnik na następną cyfrę mnożnika
    mov al, [rdx]   ; Wczytaj cyfrę mnożnika
    mul r12b    ; Pomnóż cyfrę mnożnika przez cyfrę mnożnej
    mov rcx, rdx    ; Zapisz wskaźnik na mnożnika
    xor rdx, rdx    ; Wyczyść rdx
    add al, [rdi]   ; Dodaj do wyniku wartość przeniesienia z poprzedniego mnożenia
    ; Odpowiednik instrukcji AAM
    div r13b    ; Podziel wynik przez 10
    add [rdi-1], al ; Dodaj przeniesienie
    mov [rdi], ah   ; Zapisz wynik
    mov rdx, rcx    ; Przywróć wskaźnik na mnożnik
    inc r15 ; Zwiększ iterator mnożnika
    cmp r15, r11    ; Sprawdź czy koniec mnożnika
    jl multiplier
    cmp r14, r10    ; Sprawdź czy koniec mnożnej
    jl multiplicand
remove_zeros:
    dec rdi ; Przywróć wskaźnik na wynik na pozycję początkową
    mov rax, rdi    ; Wskaźnik na łańcuch wynikowy
    mov r12b, [rax] ; Wczytaj pierwszą cyfrę wyniku
    test r12b, r12b ; Sprawdź czy zero
    jnz done   ; Jeśli nie to zakończ
    inc rax ; Przesuń wskaźnik na kolejny znak
    dec r11 ; Zmniejsz długość drugiego łańcucha (i wyniku) o 1

    ; Jeśli na początku łańcucha są dwa zera, to wynikiem mnożenia jest zero
    mov r12b, [rax] ; Wczytaj kolejną cyfrę wyniku
    test r12b, r12b ; Sprawdź czy zero
    jnz done    ; Jeśli nie to zakończ
    dec rax ; Przesuń wskaźnik na poprzednią cyfrę wyniku
    add byte [rax], '0' ; Zamień zero na postać ASCII
    jmp fin
done:
    ; Przygotuj do zmiany wyniku na postać ASCII
    mov rbx, rax
    ; Przesuń wskaźnik o długość łańcucha wynikowego
    add rbx, r10
    add rbx, r11
convert_ascii:
    ; Konwertuj na postać ASCII, dopóki nie dojdziesz do początku łańcucha
    dec rbx
    add byte [rbx], '0'
    cmp rbx, rax
    jg convert_ascii
fin:
    ; Epilog
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
