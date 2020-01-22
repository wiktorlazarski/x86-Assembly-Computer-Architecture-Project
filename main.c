#include <stdio.h>

unsigned int firstconst(char *str);

int main(int argc, char *argv[])
{
    for(int i = 1; i < argc; ++i) {
        printf("%s\t\t=>\t\t%u\n", argv[i], firstconst(argv[i]));
    }

    return 0;
}