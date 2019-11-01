# Functions

# Get real path of a file/directory
# Usage: get_realpath PATH
get_realpath() {
	# test if path exists
	[ -e "$1" ] || return 1

	if [ "$(uname)" == Darwin ] ; then
		# macOS does not support readlink -f option
		perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1"
	else
		# Linux & Windows
		local path
		if [[ "$(uname)" == CYGWIN* ]] ; then
			# convert windows paths (C:\dir\file -> /cygdrive/c/dir/file)
			# then we will find real path
			path=$(cygpath "$1")
		else
			path=$1
		fi

		# find real path
		readlink -f "$path" 2> /dev/null
	fi

	[ $? == 0 ] || return 2
}


# change time2backup command to load custom config
load_config() {
	[ $# == 0 ] && return 1

	local testconfig=$config_directory/$*

	# error if config does not exists
	[ -d "$testconfig" ] || return 2

	# create sources file
	echo "$src" > "$testconfig"/sources.conf
	[ $? != 0 ] && return 3

	echo "# time2backup configuration file v$config_version" > "$testconfig"/time2backup.conf && \
	cat "$testconfig"/time2backup.default.conf >> "$testconfig"/time2backup.conf
	[ $? != 0 ] && return 3

	# if destination not set, set it
	if [ -z "$(lb_get_config "$testconfig"/time2backup.conf destination)" ] ; then
		lb_set_config "$testconfig"/time2backup.conf destination "$dest" || return 3
	fi

	# defines time2backup command
	time2backup_cmd=("$time2backup" -c "$testconfig")
}


# Run a time2backup test
# Usage: test_t2b [OPTION] LABEL [T2B OPTIONS]
test_t2b() {
	local opts=()

	while [ $# -gt 0 ] ; do
		case $1 in
			-c)
				opts+=(-c "$2")
				shift
				;;
			-r)
				opts+=(-r "$2")
				shift
				;;
			*)
				break
				;;
		esac
		shift
	done

	opts+=(-n "$1" "${time2backup_cmd[@]}")
	shift

	lb_istrue $console_mode && opts+=(-C)
	lb_istrue $debug_mode && opts+=(-D)

	tb_test -i "${opts[@]}" "$@"
}


# Get file checksum
# Usage: get_file_checksum PATH
file_checksum() {
	[ -e "$*" ] || return 1

	md5sum "$*" 2> /dev/null | awk '{print $1}'
	[ ${PIPESTATUS[0]} == 0 ] || return 1
}


# Check file content
# Usage: test_file CONFIG CHECKSUM PATH
test_file() {
	[ $# -lt 3 ] && return 1

	local config=$1 checksum=$2
	shift 2

	tb_test -r "$checksum" -n "$config: File checksum" file_checksum "$*"
}
