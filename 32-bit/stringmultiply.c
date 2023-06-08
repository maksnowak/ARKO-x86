// ==========================================================================================
// 20. char *smul(char *d, char *s1, char *s2);
// Mnożenie długich całkowitych liczb dziesiętnych bez znaku, zapisanych jako łańcuchy cyfr,
// z wynikiem w takiej samej postaci- Program główny powinien zaalokować bufor na łańcuch
// wynikowy. W wersji 32-bitowej wskazane zastosowanie instrukcji AAM.
// ==========================================================================================

#include <stdio.h>

char *smul(char *d, char *s1, char *s2);

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Niepoprawna liczba argumentow\n");
        return 1;
    }
    if (strlen(argv[1]) == 0 || strlen(argv[2]) == 0) {
        printf("Argumenty nie moga byc puste\n");
        return 1;
    }
    char *result = malloc(strlen(argv[1]) + strlen(argv[2]));
    printf("%s * %s = ", argv[1], argv[2]);
    printf("%s\n", smul(result, argv[1], argv[2]));
    free(result);
}