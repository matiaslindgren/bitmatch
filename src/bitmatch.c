#include "bitmatch.h"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "unistd.h"

#define CHAR_LEN BITMATCH_CHAR_LEN

void char_to_bits(const char ch, char *bits) {
  for (int i = 0; i < CHAR_LEN; ++i) {
    bits[CHAR_LEN - i - 1] = (ch >> i) & 1;
  }
}

int first_nonzero_bit(char *bits) {
  int begin = 0;
  for (; begin < CHAR_LEN && bits[begin] == 0; ++begin) {
  }
  return begin;
}

char *new_bit_buffer(int n) {
  char *buf = (char *)malloc(n * sizeof(char));
  if (!buf) {
    fprintf(stderr, "unable to allocate bit buffer");
    free(buf);
    return NULL;
  }
  memset(buf, 0, n);
  return buf;
}

void extract_pattern_bits(const char *pattern, const int len, char *out_buf) {
  // Bit buffer for one character
  char bits[CHAR_LEN];
  memset(bits, 0, CHAR_LEN);

  int pos = 0;

  for (const char *p = pattern; *p != '\0'; ++p) {
    // Parse one character as hexadecimal
    char ch[2] = {*p, '\0'};
    // Maximum hex character 'f' requires 4 bits => cast to char is fine
    const char tmp = (char)strtol(ch, NULL, 16);
    // Copy bits to output buffer
    char_to_bits(tmp, bits);
    for (int j = first_nonzero_bit(bits); pos < len && j < CHAR_LEN; j++) {
      out_buf[pos] = bits[j];
      ++pos;
    }
  }
}

int search_in_file(const char *pattern_str, const int pattern_len,
                   const int fd) {
  char *pattern = new_bit_buffer(pattern_len);
  if (!pattern) {
    return 3;
  }
  extract_pattern_bits(pattern_str, pattern_len, pattern);

  // Ring buffer for bits extracted from input bytes
  char *window = new_bit_buffer(pattern_len);
  if (!window) {
    free(pattern);
    return 3;
  }

  int found = 0;

  // Bit buffer for one ASCII byte
  // When ch_bits_pos == CHAR_LEN, one byte is read from fd
  char ch_bits[CHAR_LEN];
  memset(ch_bits, 0, CHAR_LEN);
  int ch_bits_pos = CHAR_LEN;

  int bits_read = 0;

  for (int win_pos = 0;; win_pos = (win_pos + 1) % pattern_len) {
    // Compare pattern buffer to current window if the window is full
    if (bits_read >= pattern_len) {
      found = 1;
      for (int i = 0; found && i < pattern_len; ++i) {
        int j = (win_pos + i) % pattern_len;
        found = found && (pattern[i] == window[j]);
      }
    }

    // Pattern found, stop
    if (found) {
      break;
    }

    // Read one byte from fd
    if (ch_bits_pos == CHAR_LEN) {
      char next_char;
      if (read(fd, &next_char, 1) == 0) {
        // EOF, stop
        break;
      }
      // Extract bits from input byte
      char_to_bits(next_char, ch_bits);
      ch_bits_pos = 0;
    }

    // Copy next bit from input
    window[win_pos] = ch_bits[ch_bits_pos];
    ++bits_read;
    ++ch_bits_pos;
  }

  free(window);
  free(pattern);
  return found;
}

#undef CHAR_LEN
