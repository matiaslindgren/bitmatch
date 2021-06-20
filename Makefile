OUTDIR := ./build
CC := clang
CFLAGS := -g -fsanitize=undefined -Wall -Wextra -Werror
CXX := clang++
CXXFLAGS := -std=c++17

.PHONY: all dirs bitmatch bitdump clean


all: dirs bitmatch bitmatch_cpp bitdump

dirs:
	@mkdir -pv $(OUTDIR)/target

clean:
	rm -rv $(OUTDIR)

test: all
	./test.sh $(OUTDIR)/target

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


bitmatch_cpp: bitmatch_cpp_cli.o bitmatch_cpp.o bitmatch.o
	@$(CXX) $(CXXFLAGS) $(CFLAGS) -o $(OUTDIR)/target/$@ $(addprefix $(OUTDIR)/,$^)

bitmatch_cpp_cli.o: src/bitmatch_cli.cpp
	@$(CXX) $(CXXFLAGS) $(CFLAGS) -I./include -c -o $(OUTDIR)/$@ $^

bitmatch_cpp.o: src/bitmatch.cpp bitmatch.o
	@$(CXX) $(CXXFLAGS) $(CFLAGS) -I./include -c -o $(OUTDIR)/$@ $<
