#include <string>

namespace bitmatch {
  namespace c_api {
    #include "bitmatch.h"
  }
  int search_in_file(const std::string&, const int, const int);
}
