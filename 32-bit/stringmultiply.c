// ==========================================================================================
// 20. char *smul(char *d, char *s1, char *s2);
// Mnożenie długich całkowitych liczb dziesiętnych bez znaku, zapisanych jako łańcuchy cyfr,
// z wynikiem w takiej samej postaci- Program główny powinien zaalokować bufor na łańcuch
// wynikowy. W wersji 32-bitowej wskazane zastosowanie instrukcji AAM.
// ==========================================================================================

#include <stdio.h>

char *smul(char *d, char *s1, char *s2);

int main(int argc, char *argv[]) {
    char result[19]; // największy wynik mnożenia długich liczb całkowitych będzie zajmował 19 znaków
    printf("%s * %s = ", argv[1], argv[2]);
    printf("%s\n", smul(result, argv[1], argv[2]));
}