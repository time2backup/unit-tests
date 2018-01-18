# Functions

# Get real path of a file/directory
# Usage: lb_realpath PATH
lb_realpath() {

	# test if path exists
	if ! [ -e "$1" ] ; then
		return 1
	fi

	if [ "$lb_current_os" == "macOS" ] ; then
		# macOS does not support readlink -f option
		perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1"
	else
		# Linux & Windows

		if [ "$lb_current_os" == "Windows" ] ; then
			# convert windows paths (C:\dir\file -> /cygdrive/c/dir/file)
			# then we will find real path
			lb_realpath_path=$(cygpath "$1")
		else
			lb_realpath_path=$1
		fi

		# find real path
		readlink -f "$lb_realpath_path" 2> /dev/null
	fi

	# error
	if [ $? != 0 ] ; then
		return 2
	fi
}


# change time2backup command to load custom config
load_config() {

	if [ $# == 0 ] ; then
		return 1
	fi

	testconfig="$config_directory/$*"

	# error if config does not exists
	if ! [ -d "$testconfig" ] ; then
		return 2
	fi

	# create sources file
	echo "$src" > "$testconfig/sources.conf"
	if [ $? != 0 ] ; then
		return 3
	fi

	cp "$testconfig/time2backup.default.conf" "$testconfig/time2backup.conf"
	if [ $? != 0 ] ; then
		return 3
	fi

	# erase destination config
	conf_dest=$(echo "$dest" | sed 's/\//\\\//g')

	sed -i~ "s/^[# ]*destination = /destination=\"$conf_dest\"/" "$testconfig/time2backup.conf"

	if [ $? != 0 ] ; then
		return 3
	fi

	# defines time2backup command
	time2backup+=(-c "$testconfig")
}


# Run a time2backup test
# Usage: test_t2b LABEL [T2B OPTIONS]
test_t2b() {

	cmd=(tb_test -n "$1" -i)
	cmd+=("${time2backup[@]}")

	if $console_mode ; then
		cmd+=(-C)
	fi

	if $debug_mode ; then
		cmd+=(-D)
	fi

	# after label, get options
	shift
	while [ $# -gt 0 ] ; do
		cmd+=("$1")
		shift
	done

	# run test
	"${cmd[@]}"
}


# Get file checksum
# Usage: get_file_checksum PATH
file_checksum() {

	if ! [ -e "$*" ] ; then
		return 1
	fi

	md5sum "$*" 2> /dev/null | awk '{print $1}'
	if [ ${PIPESTATUS[0]} != 0 ] ; then
		return 1
	fi
}


# Check file content
# Usage: test_file CONFIG CHECKSUM PATH
test_file() {

	if [ $# -lt 3 ] ; then
		return 1
	fi

	local config=$1
	local checksum=$2
	shift 2

	tb_test -r "$checksum" -n "$config: File checksum" file_checksum "$*"
}
