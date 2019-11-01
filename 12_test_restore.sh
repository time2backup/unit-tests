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
	tb_test -n "$label: Update file111" [ $? == 0 ] && \
	"${cmd[@]}" && \
	test_file "$file111_checksum" "$file111"

	# test restore to another destination
	local other_restored=$(dirname "$file111")/restored

	cmd+=("$other_restored")

	"${cmd[@]}" && \
	test_file "$file111_checksum" "$other_restored"
}
