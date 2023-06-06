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
    mov edx, [ebp+8] ; wynik
    mov esi, [ebp+12] ; s1
    mov edi, [ebp+16] ; s2
    mov cl, 0   ; carry
    mov ch, 10 ; potrzebne do sprawdzenia przeniesienia
    mov eax, 0 ; zerowanie rejestru
    mov ebx, 0 ; zerowanie rejestru
iterate_s1:
    mov bl, [esi]
    test bl, bl
    jz iterate_s2
    inc esi
    jmp iterate_s1
iterate_s2:
    mov bl, [edi]
    test bl, bl
    jz multiply
    inc edi
    jmp iterate_s2
multiply:
    dec esi
    dec edi
multiply_digit:
    mov bl, [esi]
    mov bh, [edi]
    cmp bl, 0
    jz next_digit
    dec esi
    sub bl, '0'
    sub bh, '0'
    mul bh
    aam
    ; dodaj cyfrę jedności wyniku
    add [edx], al
    ; dodaj cyfrę dziesiątek wyniku
    add [edx+1], ah
    add [edx+1], cl ; dodaj przeniesienie
    ; sprawdź, czy jest przeniesienie
    cmp [edx+1], ch
    jge carry
    ; jeśli nie ma przeniesienia, to zwiększ wskaźnik na wynik
    inc edx
    jmp multiply_digit
carry:
    ; jeśli jest przeniesienie, zachowaj jego wartość do rejestru cl
    mov cl, 1
    ; oraz usuń je z wyniku
    sub [edx+1], ch
    ; zwiększ wskaźnik na wynik
    inc edx
    jmp multiply_digit
next_digit:
; epilog
fin:
    mov eax, [ebp+8]
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret