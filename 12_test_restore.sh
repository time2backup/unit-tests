# Test restore
# Usage: test_restore CONFIG
function test_restore() {

	local cmd=(test_t2b)

	while [ $# -gt 0 ] ; do

		if [ $# -gt 1 ] ; then
			cmd+=("$1")
		else
			local label=$1
			cmd+=("$1: Restore file111")
		fi
		shift
	done

	cmd+=(restore -f)

	if $quiet_mode ; then
		cmd+=(-q)
	fi

	cmd+=("$file111")

	# save file checksum
	file111_checksum=$(file_checksum "$file111")

	# change content, restore then check integrity
	echo newcontent > "$file111"
	tb_test -n "$label: Update file111" [ $? == 0 ] && \
	"${cmd[@]}" && \
	test_file "$file111_checksum" "$file111"
}
