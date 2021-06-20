#!/usr/bin/env bash
set -uo pipefail

if [ $# -ne 1 ]; then
	echo usage: ./test.sh ./build/target
	exit 2
fi

function assert_eq {
	if [ $2 -eq $3 ]; then
		if [ $3 -eq 0 ]; then
			echo $1: ok, pattern found
		else
			echo $1: ok, pattern not found
		fi
	else
		if [ $3 -eq 0 ]; then
			echo $1: fail, pattern not found but it was expected to be in the input
		else
			echo $1: fail, pattern found but it was not expected to be in the input
		fi
		return 1
	fi
	return 0
}

function run_test {
	local input="$1"
	local expected_out=$2
	printf 'input: '
	echo "$input" | $target_dir/bitdump
	for target in $target_dir/bitmatch{,_cpp,_dyn}; do
		echo "$input" | $target f8c 11
		assert_eq $target $? $expected_out
		out=$?
		if [ $fail -eq 0 ]; then
			fail=$out
		fi
	done
}


target_dir=$1
fail=0

echo searching for 11 first bits of f8c
run_test 'h>0?' 0
run_test 'h<0?' 1

exit $fail
