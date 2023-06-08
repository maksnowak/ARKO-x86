; ==========================================================================================
; 20. char *smul(char *d, char *s1, char *s2);
; Mnożenie długich całkowitych liczb dziesiętnych bez znaku, zapisanych jako łańcuchy cyfr,
; z wynikiem w takiej samej postaci- Program główny powinien zaalokować bufor na łańcuch
; wynikowy. W wersji 32-bitowej wskazane zastosowanie instrukcji AAM.
; ==========================================================================================

    section .text
    global smul
; prolog
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
    mov esi, ecx    ; Zapisz długość pierwszego łańcucha w rejestrze
    push ecx    ; Zapisz długość pierwszego łańcucha na stosie
    mov ebx, [ebp+8]    ; Wskaźnik na łańcuch wynikowy
    add ebx, esi    ; Przesuń wskaźnik na koniec łańcucha wynikowego
    inc ebx     ; Przesuń wskaźnik na pierwszy znak poza łańcuchem wynikowym
    add esi, [ebp+12]  ; Przesuń wskaźnik na koniec pierwszego łańcucha
multiplicand:
    add ebx, edx    ; Przesuń wskaźnik na koniec łańcucha wynikowego
    dec ebx     ; Przesuń wskaźnik na ostatni znak łańcucha wynikowego
    dec esi    ; Przesuń wskaźnik na następną cyfę mnożnej
    mov cl, [esi]    ; Wczytaj cyfrę mnożnej
    ; Przejdź do ostatniej cyfry mnożnika
    mov edi, edx
    add edi, [ebp+16]
multiplier:
    dec ebx     ; Przesuń wskaźnik na następną cyfrę wyniku
    dec edi     ; Przesuń wskaźnik na następną cyfrę mnożnika
    mov al, [edi]    ; Wczytaj cyfrę mnożnika
    mul cl      ; Pomnóż cyfrę mnożnika przez cyfrę mnożnej
    add al, [ebx]    ; Dodaj cyfrę wyniku
    aam     ; Skoryguj wynik
    add [ebx-1], ah     ; Dodaj cyfrę dziesiątek do poprzedniej cyfry wyniku
    mov [ebx], al   ; Zapisz cyfrę jedności w wyniku
    cmp edi, [ebp+16]   ; Sprawdź czy to ostatnia cyfra mnożnika
    jne multiplier
    cmp esi, [ebp+12]   ; Sprawdź czy to ostatnia cyfra mnożnej
    jne multiplicand
remove_zeros:
    mov eax, [ebp+8]    ; Wskaźnik na łańcuch wynikowy
    mov cl, [eax]   ; Wczytaj pierwszą cyfrę wyniku
    test cl, cl     ; Sprawdź czy to null
    jnz done     ; Jeśli nie, to zakończ
    inc eax     ; Przesuń wskaźnik na następną cyfrę wyniku
    dec edx     ; Przesuń wskaźnik na następną cyfrę mnożnej
    mov cl, [eax]   ; Wczytaj następną cyfrę wyniku
    test cl, cl     ; Sprawdź czy to null
    jnz done      ; Jeśli tak, to zakończ
    ; Jeśli na początku łańcucha są dwa zera, to wynikiem mnożenia jest zero
    dec eax     ; Przesuń wskaźnik na poprzednią cyfrę wyniku
    add byte [eax], '0' ; Zamień null na zero
    pop ecx
    jmp fin
done:
    mov ebx, eax
    pop ecx
    add ebx, ecx
    add ebx, edx
convert_ascii:
    dec ebx
    add byte [ebx], '0'
    cmp ebx, eax
    jg convert_ascii
fin:
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret