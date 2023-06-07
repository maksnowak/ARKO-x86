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
    mov esi, [ebp+12] ; s1
    mov edi, [ebp+16] ; s2
    mov bl, 0   ; carry
    mov bh, 10 ; potrzebne do sprawdzenia przeniesienia
    mov eax, 0 ; zerowanie rejestru
    mov ecx, 0 ; zerowanie rejestru
iterate_s1:
    mov al, [esi]
    test al, al
    jz iterate_s2
    inc esi
    jmp iterate_s1
iterate_s2:
    mov al, [edi]
    test al, al
    jz multiply
    inc edi
    jmp iterate_s2
multiply:
    dec esi
    dec edi
multiply_digit:
    mov al, [esi]
    mov ah, [edi]
    cmp al, 0
    jz next_digit
    dec esi
    sub al, '0'
    sub ah, '0'
    mul ah
    aam
    ; dodaj cyfrę jedności wyniku
    add [ecx], al
    ; dodaj cyfrę dziesiątek wyniku
    add [ecx+1], ah
    add [ecx+1], bl ; dodaj przeniesienie
    ; sprawdź, czy jest przeniesienie
    cmp [ecx+1], bh
    jge carry
    ; jeśli nie ma przeniesienia, to zwiększ wskaźnik na wynik
    inc ecx
    jmp multiply_digit
carry:
    ; jeśli jest przeniesienie, zachowaj jego wartość do rejestru cl
    mov bl, 1
    ; oraz usuń je z wyniku
    sub [ecx+1], bh
    ; zwiększ wskaźnik na wynik
    inc ecx
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