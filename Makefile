OUTDIR := ./bin

.PHONY: all dirs bitmatch bitdump clean

all: bitmatch bitdump

dirs:
	@mkdir -pv $(OUTDIR)

bitmatch bitdump: dirs
	@clang -x c -o $(OUTDIR)/$@ -fsanitize=undefined -Wall -Wextra -Werror -I./include ./src/$@.c

clean:
	@rm -rv $(OUTDIR)

test: all
	@./test.sh $(OUTDIR)
