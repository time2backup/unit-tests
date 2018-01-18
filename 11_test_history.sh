# Test history
# Usage: test_history CONFIG
function test_history() {
	test_t2b "$1: History" history -q "$file111"
}
