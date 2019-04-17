# Test clean command
function test_clean() {
	test_t2b "$1: clean file111" clean -f "$file111" && \
	test_t2b -c 5 "$1: file111 not exists" history -q "$file111"
}
