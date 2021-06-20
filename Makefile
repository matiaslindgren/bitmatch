OUTDIR ?= ./build
CC ?= clang
CXX ?= clang++
CFLAGS ?= -g -Wall -Wextra -Werror
CXXFLAGS ?= -std=c++17

BUILD ?= debug
ifeq ($(BUILD),release)
	CFLAGS := $(CFLAGS) -O3
else
	CFLAGS := $(CFLAGS) -fsanitize=undefined
endif

ifeq ($(shell uname),Darwin)
	SHARED_LIB_EXT := dylib
	SHARED_LIB_FLAGS := -dynamiclib
else
	SHARED_LIB_EXT := so
	SHARED_LIB_FLAGS := -shared
endif

.PHONY: all dirs bitmatch bitmatch_cpp bitdump clean


all: dirs bitdump bitmatch

dirs:
	mkdir -pv $(OUTDIR)/target

clean:
	rm -rv $(OUTDIR)

bitdump: src/bitdump_cli.c src/bitmatch.c
	@$(CC) $(CFLAGS) -I./include -o $(OUTDIR)/target/$@ $^


bitmatch: bitmatch_cli.o libbitmatch.a
	@$(CC) $(CFLAGS) -L$(OUTDIR) -o $(OUTDIR)/target/$@ $(OUTDIR)/$< -lbitmatch

bitmatch_cli.o: src/bitmatch_cli.c
	@$(CC) $(CFLAGS) -I./include -c -o $(OUTDIR)/$@ $^

libbitmatch.a: bitmatch.o
	@ar -rcs $(OUTDIR)/$@ $(OUTDIR)/$^

bitmatch.o: src/bitmatch.c
	@$(CC) $(CFLAGS) -I./include -c -o $(OUTDIR)/$@ $^


bitmatch_cpp: bitmatch_cpp_cli.o libbitmatch_cpp.a
	@$(CXX) $(CXXFLAGS) $(CFLAGS) -L$(OUTDIR) -o $(OUTDIR)/target/$@ $(OUTDIR)/$< -lbitmatch_cpp

bitmatch_cpp_cli.o: src/bitmatch_cli.cpp
	@$(CXX) $(CXXFLAGS) $(CFLAGS) -I./include -c -o $(OUTDIR)/$@ $^

libbitmatch_cpp.a: bitmatch_cpp.o bitmatch.o
	@ar -rcs $(OUTDIR)/$@ $(addprefix $(OUTDIR)/,$^)

bitmatch_cpp.o: src/bitmatch.cpp
	@$(CXX) $(CXXFLAGS) $(CFLAGS) -I./include -c -o $(OUTDIR)/$@ $^


bitmatch_dyn: libbitmatch.$(SHARED_LIB_EXT)
	@$(CC) $(CFLAGS) -L$(OUTDIR) -o $(OUTDIR)/target/$@ -fPIC -I./include src/bitmatch_cli.c -lbitmatch

libbitmatch.$(SHARED_LIB_EXT): shared_bitmatch.o
	@$(CC) $(CFLAGS) -o $(OUTDIR)/$@ $(SHARED_LIB_FLAGS) -fPIC $(OUTDIR)/$^

shared_bitmatch.o: src/bitmatch.c
	@$(CC) $(CFLAGS) -I./include -c -o $(OUTDIR)/$@ -fPIC $^
