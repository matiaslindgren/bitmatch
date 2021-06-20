#include "bitmatch.h"
#include "stdio.h"
#include "stdlib.h"
#include "unistd.h"

int main(int argc, const char **argv) {
  if (argc != 3) {
    fprintf(stderr, "usage: bitmatch pattern length\n");
    return 2;
  }
  const char *pattern = argv[1];
  const int pattern_len = atoi(argv[2]);
  int found = search_in_file(pattern, pattern_len, STDIN_FILENO);
  return !found;
}
