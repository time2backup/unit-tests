# Test restore
# Usage: test_restore CONFIG
function test_restore() {

	# save file checksum
	file111_checksum=$(file_checksum "$file111")

	# change content, restore then check integrity
	echo newcontent > "$file111"
	tb_test -n "$1: Update file111" [ $? == 0 ] && \
	test_t2b "$1: Restore file111" restore -f "$file111" && \
	test_file "$file111_checksum" "$file111"
}
