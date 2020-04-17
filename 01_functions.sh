# Functions

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

	opts+=(-n "$1" "$t2b_path/time2backup.sh" -c "$config_directory/$conf")
	shift

	lb_istrue $console_mode && opts+=(-C)
	lb_istrue $debug_mode && opts+=(-D)

	tb_test -i "${opts[@]}" "$@"
}


# Get file checksum
# Usage: file_checksum PATH
file_checksum() {
	if lb_command_exists md5sum ; then
		md5sum "$*" | awk '{print $1}'
	else
		md5 -r "$*" | awk '{print $1}'
	fi

	return ${PIPESTATUS[0]}
}


# Check file content
# Usage: test_file CONFIG CHECKSUM PATH
test_file() {
	local config=$1 checksum=$2
	shift 2

	tb_test -r "$checksum" -n "$config: File checksum $*" file_checksum "$*"
}


# Analyse args
# Usage: expected_code ARGS
expected_code() {
	while [ $# -gt 0 ] ; do
		case $1 in
			-c|--exit-code)
				return $2
				;;
		esac
		shift
	done
}
