# Test clean command
# Usage: test_clean [OPTIONS]
# Dependencies: $conf
function test_clean() {
	test_t2b "$@" "$conf: clean file111" clean -f "$file111" && \
	test_t2b -c 5 "$conf: file111 has been cleaned" history -q "$file111"
}
