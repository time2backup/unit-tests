# run tests for every type of config

# parse every config
for dir in "$config_directory"/* ; do
	# get directory name
	conf=$(basename "$dir")

	# load config
	if ! [ -d "$config_directory/$conf" ] ; then
		tb_test -n "$conf: Load config" false
		continue
	fi

	echo
	echo "---------  Test config $conf  ---------"
	echo

	# load config; if error, quit
	tb_test -n "$conf: Load config" -i load_config $conf || continue

	# test usage errors
	test_t2b -c 1 "$conf: Usage error" history &> /dev/null

	# load expected results config
	if [ -f "$config_directory/$conf/tests.conf" ] ; then
		source "$config_directory/$conf/tests.conf" || tb_test -n "$conf: Load tests" false
	else
		# default tests
		test_backup && \
		test_history && \
		test_restore
		test_mv
		test_clean
		test_export
	fi

	# clear backup files
	tb_test -n "$conf: Clear backup files" rm -rf "$dest"/*
done

# clear files
tb_test -n "Clear all files" rm -rf "$testdir"
