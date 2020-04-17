# Test restore
# Usage: test_restore [OPTIONS]
# Dependencies: $conf
function test_restore() {
	local cmd=(test_t2b "$@" "$conf: Restore file111" restore -f)

	lb_istrue $quiet_mode && cmd+=(-q)

	cmd+=("$file111")

	# save file checksum
	file111_checksum=$(file_checksum "$file111")

	# change content, restore file then check integrity
	echo newcontent > "$file111"
	tb_test -n "$conf: Update file111" [ $? == 0 ] && \
	"${cmd[@]}" && \
	test_file "$conf" "$file111_checksum" "$file111"

	# test restore to another destination
	local other_restore=$dir1/new/path/to/restore

	"${cmd[@]}" "$other_restore" && \
	test_file "$conf" "$file111_checksum" "$other_restore"
}
