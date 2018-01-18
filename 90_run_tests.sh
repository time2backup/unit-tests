# run tests for every type of config

# parse every config
for dir in "$config_directory/"* ; do

	# get directory name
	d=$(basename "$dir")

	# load config
	if ! [ -d "$config_directory/$d" ] ; then
		tb_test -n "$d: Load config" false
		continue
	fi

	echo
	echo "---------  Test config $d  ---------"
	echo

	# load config; if error, quit
	tb_test -n "$d: Load config" -i load_config "$d" || continue

	# run tests
	test_backup $d && \
	test_history $d && \
	test_restore $d
	test_mv $d
	#test_clear $d

	# clear backup files
	tb_test -n "$d: Clear backup files" rm -rf "$dest"/*
done

return 0
