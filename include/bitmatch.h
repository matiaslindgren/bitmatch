#ifndef INCLUDE_BITMATCH_H
#define INCLUDE_BITMATCH_H

#ifdef __cplusplus
extern "C" {
#endif

// Bits in a char
#define BITMATCH_CHAR_LEN 8

#define BITMATCH_USAGE                                                         \
  "usage: bitmatch hex_pattern prefix_length\n"                                \
  "  hex_pattern: string in hexadecimal of the pattern to search for. E.g. "   \
  "hex_pattern f8c will search for 111110001100\n"                             \
  "  prefix_length: number of bits to use from the beginning of hex_pattern. " \
  "E.g. prefix_length 9 would search for 111110001."

// Extract each bit of 'ch' into array 'bits' such that the MSB is at index
// 0.
void char_to_bits(const char ch, char *bits);

// Find the first non-zero bit and return its index.
// Return BITMATCH_CHAR_LEN if bits contains only zeros.
int first_nonzero_bit(char *bits);

// Allocate a new array of 'n' chars for storing individual bits.
// The user is responsible of freeing the array.
char *new_bit_buffer(int n);

// Given a hexadecimal string 'pattern', its length 'len', and a bit buffer
// 'out_buf' of length 'len':
// 1. Parse each character in 'pattern' as a hexadecimal number.
// 2. Extract bits of each number, discarding leading zeros.
// 3. Store each bit in 'out_buf'.
void extract_pattern_bits(const char *pattern, const int len, char *out_buf);

// Given a hexadecimal string 'pattern', its length 'len', and a file descriptor
// 'fd', search for the given bit pattern in the file.
// Returns 1 if the pattern is present in the file and 0 otherwise.
int search_in_file(const char *pattern_str, const int pattern_len,
                   const int fd);

#ifdef __cplusplus
}
#endif

#endif // INCLUDE_BITMATCH_H
