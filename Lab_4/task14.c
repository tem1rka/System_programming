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
    if (errno || (*end && *end != '\n') || n > 1000000ULL) return 1;
    uint64_t power = 10;
    for (uint64_t k = 1; k <= n; ++k) {
        if (k == power) power *= 10;
        if (k*k % power == k) printf("%" PRIu64 "\n", k);
    }
    return 0;
}
