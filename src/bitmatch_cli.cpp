#include "bitmatch.hh"
#include <cstdlib>
#include <iostream>
#include <string>
#include <unistd.h>

int main(int argc, const char **argv) {
  if (argc != 3) {
    std::cerr << BITMATCH_USAGE << "\n";
    return 2;
  }
  const std::string pattern{argv[1]};
  const int pattern_len = std::atoi(argv[2]);
  int found = bitmatch::search_in_file(pattern, pattern_len, STDIN_FILENO);
  return !found;
}
