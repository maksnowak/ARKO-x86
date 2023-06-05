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
    mov eax, [ebp+8] ; wynik
    mov esi, [ebp+12] ; s1
    mov edi, [ebp+16] ; s2
; epilog
fin:
    mov eax, [ebp+8]
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret