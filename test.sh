#!/usr/bin/env sh
set -uo pipefail

if [ $# -ne 1 ]; then
	echo usage ./test.sh outdir
	exit 2
fi

outdir=$1
fail=0

echo searching for 11 first bits of f8c

echo
printf 'input: '
echo 'h>0?' | $outdir/bitdump
echo 'h>0?' | $outdir/bitmatch f8c 11
if [ $? -eq 0 ]; then
	echo ok, pattern found
else
	echo fail, pattern not found but it is in the input
	fail=1
fi

echo
printf 'input: '
echo 'h<0?' | $outdir/bitdump
echo 'h<0?' | $outdir/bitmatch f8c 11
if [ $? -eq 1 ]; then
	echo ok, pattern not found
else
	echo fail, pattern found but it is not in the input
	fail=1
fi

exit $fail
