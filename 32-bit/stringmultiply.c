// ==========================================================================================
// 20. char *smul(char *d, char *s1, char *s2);
// Mnożenie długich całkowitych liczb dziesiętnych bez znaku, zapisanych jako łańcuchy cyfr,
// z wynikiem w takiej samej postaci- Program główny powinien zaalokować bufor na łańcuch
// wynikowy. W wersji 32-bitowej wskazane zastosowanie instrukcji AAM.
// ==========================================================================================

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
    printf("%s * %s = ", argv[1], argv[2]);
    char *result_buf = malloc(strlen(argv[1]) + strlen(argv[2]));
    char *result = smul(result_buf, argv[1], argv[2]);
    puts(result);
    free(result_buf);
    return 0;
}