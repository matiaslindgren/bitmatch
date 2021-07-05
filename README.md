# bitmatch

Search for bit patterns in standard input.
Probably useless.

## Example
Search for first 11 bits of `f8c` (`1111 1000 110`) in the input:
```console
$ echo 'h>0?' | ./bitmatch f8c 11 || echo not found
$ echo 'h<0?' | ./bitmatch f8c 11 || echo not found
not found
```

### Explanation

Input data `h>0?` as bits:
```console
$ echo 'h>0?' | xxd -b
00000000: 01101000 00111110 00110000 00111111 00001010           h>0?.
```
First 11 bits of pattern `f8c`:
```console
$ pattern="$(echo f8c | python3 -c 'print("".join(format(int(c, 16), "b") for c in input())[:11])')"
$ echo $pattern
11111000110
```
The bit pattern can be found in the input for example with `grep`:
```console
$ echo 'h>0?' | xxd -b | tr -d ' ' | grep "$pattern" || echo not found
00000000:0110100000111110001100000011111100001010h>0?.
$ echo 'h<0?' | xxd -b | tr -d ' ' | grep "$pattern" || echo not found
not found
```

That's basically the only thing `bitmatch` does.

## Usage

```console
$ ./bitmatch
usage: bitmatch hex_pattern prefix_length
  hex_pattern: string in hexadecimal of the pattern to search for. E.g. hex_pattern f8c will search for 111110001100
  prefix_length: number of bits to use from the beginning of hex_pattern. E.g. prefix_length 9 would search for 111110001.
```

## Build & test

```sh
make all
./test.sh ./build/target bitmatch
```

### With GCC

```sh
make CC=gcc CXX=g++ all
```

### Release

```sh
make BUILD=release all
```

### C++ API

```sh
make dirs bitdump bitmatch_cpp
./test.sh ./build/target bitmatch_cpp
```

### Shared library

```sh
make dirs bitdump bitmatch_dyn
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:./build
./test.sh ./build/target bitmatch_dyn
```
