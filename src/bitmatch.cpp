#include "bitmatch.hh"
#include <string>

namespace bitmatch {
int search_in_file(const std::string &pattern, const int pattern_len,
                   const int fd) {
  return c_api::search_in_file(pattern.c_str(), pattern_len, fd);
}
} // namespace bitmatch
