#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <errno.h>
#include <inttypes.h>
static int64_t number(const char *s) {
    char *end;
    errno = 0;
    int64_t x = strtoll(s, &end, 10);
    if (errno || !*s || *end) exit(1);
    return x;
}
int main(int argc, char **argv) {
    if (argc != 4) return 1;
    int64_t a = number(argv[1]), b = number(argv[2]), c = number(argv[3]);
    if (!b || !c || (c == INT64_MIN && b == -1)) return 1;
    int64_t x;
    if (__builtin_add_overflow(c / b, a, &x)) return 1;
    if (x == INT64_MIN && c == -1) return 1;
    if (__builtin_add_overflow(x / c, a, &x)) return 1;
    printf("%" PRId64 "\n", x);
    return 0;
}
