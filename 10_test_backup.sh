# Test backup
# Usage: test_backup [OPTIONS]
# Dependencies: $conf
function test_backup() {
	local opts=()
	lb_istrue $quiet_mode && opts+=(-q)

	test_t2b "$@" "$conf: Backup" backup "${opts[@]}"
}
