# Test history
# Usage: test_history [OPTIONS]
# Dependencies: $conf
function test_history() {
	test_t2b "$@" "$conf: History" history -q "$file111"
}
