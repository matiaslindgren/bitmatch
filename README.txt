Building with Clang:

make all

Testing:

make all && ./test.sh ./build/target

Building with GCC:

make CC=gcc CXX=g++ all

Tested only on Apple M1, macOS Big Sur.
