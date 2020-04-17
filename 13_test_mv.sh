# Test mv command
# Usage: test_mv [OPTIONS]
# Dependencies: $conf
function test_mv() {
	if test_t2b "$@" "$conf: mv file112 file999" mv -f "$file112" "$dir11"/to/new/file999 ; then
		! expected_code "$@" || test_t2b "$@" "$conf: file999 exists" history -q "$dir11"/to/new/file999
	fi
}
