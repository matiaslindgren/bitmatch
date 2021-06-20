# bitmatch

Search for bit patterns in standard input.
Probably useless.

```
$ # look for 1111 1000 110 in the input
$ echo 'h>0?' | ./bitmatch f8c 11 || echo not found
$ echo 'h<0?' | ./bitmatch f8c 11 || echo not found
not found
```
```
$ ./bitmatch
usage: bitmatch hex_pattern prefix_length
  hex_pattern: string in hexadecimal of the pattern to search for. E.g. hex_pattern f8c will search for 111110001100
  prefix_length: number of bits to use from the beginning of hex_pattern. E.g. prefix_length 9 would search for 111110001.
```

## Build & test

```
make all
./test.sh ./build/target
```

### With GCC

```
make CC=gcc CXX=g++ all
```

### Release

```
make BUILD=release all
```
