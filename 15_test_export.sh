# Test copy command
# Usage: test_export [OPTIONS]
# Dependencies: $conf
function test_export() {
	test_t2b "$@" "$conf: export" export -f "$testdir"/dest2
}
