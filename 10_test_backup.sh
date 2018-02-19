# Test backup
# Usage: test_backup CONFIG
function test_backup() {

	local cmd=(test_t2b)

	while [ $# -gt 0 ] ; do

		if [ $# -gt 1 ] ; then
			cmd+=("$1")
		else
			cmd+=("$1: Backup")
		fi
		shift
	done

	cmd+=(backup)

	"${cmd[@]}"
}
