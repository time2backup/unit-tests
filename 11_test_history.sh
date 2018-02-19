# Test history
# Usage: test_history CONFIG
function test_history() {

	local cmd=(test_t2b)

	while [ $# -gt 0 ] ; do

		if [ $# -gt 1 ] ; then
			cmd+=("$1")
		else
			cmd+=("$1: History")
		fi
		shift
	done

	cmd+=(history -q "$file111")

	"${cmd[@]}"
}
