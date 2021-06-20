#ifndef INCLUDE_DEBUG_UTIL_H
#define INCLUDE_DEBUG_UTIL_H

#ifdef __cplusplus
extern "C" {
#endif

#include "bitmatch.h"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "unistd.h"

#define CHAR_LEN BITMATCH_CHAR_LEN

void dump_bit_buffer(char *buf, int offset, int n) {
  for (int i = 0; i < n; ++i) {
    printf("%d", buf[(offset + i) % n]);
  }
  printf("\n");
}

void dump_bits_in_file(int fd) {
  char ch_bits[CHAR_LEN];
  memset(ch_bits, 0, CHAR_LEN);
  for (char ch; read(fd, &ch, 1) > 0;) {
    char_to_bits(ch, ch_bits);
    for (int i = 0; i < CHAR_LEN; i++) {
      printf("%d", ch_bits[i]);
    }
    printf(" ");
  }
}

#undef CHAR_LEN

#ifdef __cplusplus
}
#endif

#endif // INCLUDE_DEBUG_UTIL_H
