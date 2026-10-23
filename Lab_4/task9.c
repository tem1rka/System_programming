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
    if (errno || (*end && *end != '\n') || n > 1000000000ULL) return 1;
    int64_t sum = 0;
    for (uint64_t k = 1; k <= n; ++k)
        sum += ((k-1) & 2) ? -(int64_t)k : (int64_t)k;
    printf("%" PRId64 "\n", sum);
    return 0;
}
