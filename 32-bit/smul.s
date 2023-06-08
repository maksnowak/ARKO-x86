; ==========================================================================================
; 20. char *smul(char *d, char *s1, char *s2);
; Mnożenie długich całkowitych liczb dziesiętnych bez znaku, zapisanych jako łańcuchy cyfr,
; z wynikiem w takiej samej postaci- Program główny powinien zaalokować bufor na łańcuch
; wynikowy. W wersji 32-bitowej wskazane zastosowanie instrukcji AAM.
; ==========================================================================================

    section .text
    global smul
; Prolog
smul:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    xor eax, eax    ; Wyczyść zawartość eax
convert_first:
    xor ecx, ecx    ; Wyczyść rejestr przechowujący długość łańcucha
    mov esi, [ebp+12]   ; Wskaźnik na pierwszy łańcuch
first_loop:
    mov al, [esi+ecx]   ; Wczytaj n-ty znak z łańcucha (n = ecx)
    sub al, '0'     ; Zamień znak na odpowiadającą mu liczbę
    xchg al, [esi+ecx]  ; Zamień liczbę i odpowiadający jej znak
    inc ecx     ; Zwiększ długość łańcucha
    test al, al     ; Sprawdź czy null
    jnz first_loop
    dec ecx     ; Zmniejsz długość łańcucha o 1 - ostatni znak to null
convert_second:
    xor edx, edx    ; Wyczyść rejestr przechowujący długość łańcucha
    mov edi, [ebp+16]   ; Wskaźnik na drugi łańcuch
second_loop:
    mov al, [edi+edx]   ; Wczytaj n-ty znak z łańcucha (n = edx)
    sub al, '0'     ; Zamień znak na odpowiadającą mu liczbę
    xchg al, [edi+edx]  ; Zamień liczbę i odpowiadający jej znak
    inc edx     ; Zwiększ długość łańcucha
    test al, al     ; Sprawdź czy null
    jnz second_loop
    dec edx     ; Zmniejsz długość łańcucha o 1 - ostatni znak to null
multiply:
    ; Przygotowania do wykonania mnożenia pisemnego
    mov esi, ecx    ; Zapisz długość pierwszego łańcucha w rejestrze
    push ecx    ; Zapisz długość pierwszego łańcucha na stosie - zabrakło rejestrów
    mov ebx, [ebp+8]    ; Wskaźnik na łańcuch wynikowy
    add ebx, esi    ; Przesuń wskaźnik wynikowy o długość pierwszego łańcucha
    inc ebx     ; Przesuń wskaźnik na pierwszy znak poza łańcuchem wynikowym
    add esi, [ebp+12]  ; Przesuń wskaźnik na koniec pierwszego łańcucha
multiplicand:
    ; Mnożenie mnożnej przez kolejne cyfry mnożnika
    add ebx, edx    ; Przesuń wskaźnik wynikowy o długość drugiego łańcucha
    dec ebx     ; Przesuń wskaźnik o jeden w lewo
    dec esi    ; Przesuń wskaźnik na następną cyfę mnożnej
    mov cl, [esi]    ; Wczytaj cyfrę mnożnej
    ; Przejdź do ostatniej cyfry mnożnika
    mov edi, edx
    add edi, [ebp+16]
multiplier:
    ; Mnożenie pisemne - jeden bajt to jedna cyfra
    dec ebx
    dec edi
    mov al, [edi]    ; Wczytaj cyfrę mnożnika
    mul cl      ; Pomnóż cyfrę mnożnika przez cyfrę mnożnej
    add al, [ebx]    ; Dodaj wartość przeniesienia z poprzedniego mnożenia
    aam     ; Skoryguj wynik
    add [ebx-1], ah     ; Dodaj przeniesienie
    mov [ebx], al   ; Zapisz cyfrę jedności
    cmp edi, [ebp+16]   ; Sprawdź czy cały mnożnik został przemnożony
    jne multiplier
    cmp esi, [ebp+12]   ; Sprawdź czy cała mnożna została przemnożona
    jne multiplicand
remove_zeros:
    mov eax, [ebp+8]    ; Wskaźnik na łańcuch wynikowy
    mov cl, [eax]   ; Wczytaj pierwszą cyfrę wyniku
    test cl, cl     ; Sprawdź czy to null
    jnz done     ; Jeśli nie, to zakończ
    inc eax     ; Przesuń wskaźnik na następną cyfrę wyniku
    dec edx     ; Zmniejsz długość drugiego łańcucha (i wyniku) o 1

    ; Jeśli na początku łańcucha są dwa zera, to wynikiem mnożenia jest zero
    mov cl, [eax]   ; Wczytaj następną cyfrę wyniku
    test cl, cl     ; Sprawdź czy to null
    jnz done      ; Jeśli tak, to zakończ
    dec eax     ; Przesuń wskaźnik na poprzednią cyfrę wyniku
    add byte [eax], '0' ; Zamień null na zero
    pop ecx ; Opróżnij stos
    jmp fin
done:
    ; Przygotuj do zmiany wyniku na postać ASCII
    mov ebx, eax
    pop ecx ; Opróżnij stos
    ; Przesuń wskaźnik o długość łańcucha wynikowego
    add ebx, ecx
    add ebx, edx
convert_ascii:
    ; Konwertuj wynik na postać ASCII, dopóki nie dojdziesz do początku łańcucha
    dec ebx
    add byte [ebx], '0'
    cmp ebx, eax
    jg convert_ascii
fin:
    ; Epilog
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret