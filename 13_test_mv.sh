# Test backup
# Usage: test_backup CONFIG
function test_mv() {
	test_t2b "$1: mv file112 file999" mv -f "$file112" "$dir11/file999" && \
	test_t2b "$1: file999 exists" history -q "$dir11/file999"
}
