#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <errno.h>
int main(void) {
    char s[64], *end;
    if (!fgets(s, sizeof s, stdin) || s[0] < '0' || s[0] > '9') return 1;
    errno = 0;
    uint64_t n = strtoull(s, &end, 10);
    if (errno || (*end && *end != '\n') || n > 999999999ULL) return 1;
    uint64_t result = 0, place = 10;
    do { result += n % 10 * place; n /= 10; place *= 100; } while (n);
    printf("%" PRIu64 "\n", result);
    return 0;
}
