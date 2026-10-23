#include <stdio.h>
#include <stdint.h>
int main(void) {
    uint64_t n = 2269503710ULL;
    unsigned sum = 0;
    do { sum += n % 10; n /= 10; } while (n);
    printf("%u\n", sum);
    return 0;
}
