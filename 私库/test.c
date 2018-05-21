#include <stdio.h>

int main(int argc, char **argv){

    int a;
    long b;

    union apple {
        char pen[8];
        int pie;
    };

    struct melon {
        char one;
        int two;
        char three;
        int four;
    };

    union apple swf;
    int *pear = (int *)&(swf.pen[7]);

    *pear = 7;

    printf("%d\n", *pear);
    printf("%ld;%ld\n", sizeof(union apple), sizeof(struct melon));
    printf("%ld;%ld;%ld\n", sizeof(int), sizeof(long), sizeof(long long));
    printf("%ld;%ld;%ld\n", sizeof(int), sizeof(long), sizeof(long long));
}
