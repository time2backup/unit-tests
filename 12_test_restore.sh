# Test restore
# Usage: test_restore [OPTIONS]
# Dependencies: $conf
function test_restore() {
	local cmd=(test_t2b "$@" "$conf: Restore file111" restore -f)

	lb_istrue $quiet_mode && cmd+=(-q)

	local path=$file111

	# save file checksum
	file111_checksum=$(file_checksum "$file111")

	if lb_istrue $clone_mode ; then
		path=$dest/dir1/subdir1/file1
	else
		# change content, restore file then check integrity
		echo newcontent > "$file111"
		tb_test -n "$conf: Update file111" [ $? = 0 ] && \
		"${cmd[@]}" "$path"
		expected_code "$@" && test_file "$conf" "$file111_checksum" "$file111"
	fi

	# test restore to another destination
	local other_restore=$dir1/new/path/to/restore

	"${cmd[@]}" "$path" "$other_restore"
	test_file "$conf" "$file111_checksum" "$other_restore"
}
