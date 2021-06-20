OUTDIR := ./build
CC := clang
CXX := clang++
CFLAGS := -g -Wall -Wextra -Werror
CXXFLAGS := -std=c++17

BUILD ?= debug
ifeq ($(BUILD),release)
	CFLAGS := $(CFLAGS) -O3
else
	CFLAGS := $(CFLAGS) -fsanitize=undefined
endif

.PHONY: all dirs bitmatch bitmatch_cpp bitdump clean


all: dirs bitdump bitmatch bitmatch_cpp bitmatch_dyn

dirs:
	@mkdir -pv $(OUTDIR)/target

clean:
	rm -rv $(OUTDIR)

bitdump: src/bitdump_cli.c src/bitmatch.c
	@$(CC) $(CFLAGS) -I./include -o $(OUTDIR)/target/$@ $^


bitmatch: bitmatch_cli.o bitmatch.a
	@$(CC) $(CFLAGS) -o $(OUTDIR)/target/$@ $(addprefix $(OUTDIR)/,$^)

bitmatch_cli.o: src/bitmatch_cli.c
	@$(CC) $(CFLAGS) -I./include -c -o $(OUTDIR)/$@ $^

bitmatch.a: bitmatch.o
	@ar -rcs $(OUTDIR)/$@ $(OUTDIR)/$^

bitmatch.o: src/bitmatch.c
	@$(CC) $(CFLAGS) -I./include -c -o $(OUTDIR)/$@ $^


bitmatch_cpp: bitmatch_cpp_cli.o bitmatch_cpp.a
	@$(CXX) $(CXXFLAGS) $(CFLAGS) -o $(OUTDIR)/target/$@ $(addprefix $(OUTDIR)/,$^)

bitmatch_cpp_cli.o: src/bitmatch_cli.cpp
	@$(CXX) $(CXXFLAGS) $(CFLAGS) -I./include -c -o $(OUTDIR)/$@ $^

bitmatch_cpp.a: bitmatch_cpp.o bitmatch.o
	@ar -rcs $(OUTDIR)/$@ $(addprefix $(OUTDIR)/,$^)

bitmatch_cpp.o: src/bitmatch.cpp
	@$(CXX) $(CXXFLAGS) $(CFLAGS) -I./include -c -o $(OUTDIR)/$@ $^


bitmatch_dyn: bitmatch.dylib
	@$(CC) $(CFLAGS) -o $(OUTDIR)/target/$@ -I./include src/bitmatch_cli.c $(OUTDIR)/$^

bitmatch.dylib: src/bitmatch.c
	@$(CC) $(CFLAGS) -I./include -o $(OUTDIR)/$@ -dynamiclib $^
