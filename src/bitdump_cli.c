#include "debug_util.h"
#include "stdio.h"
#include "unistd.h"

int main(void) {
  dump_bits_in_file(STDIN_FILENO);
  printf("\n");
  return 0;
}
