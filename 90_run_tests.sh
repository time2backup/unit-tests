# run tests for every type of config

# parse every config
for dir in "$config_directory/good/"* ; do
	# get directory name
	d=$(basename "$dir")

	# load config
	if ! [ -d "$config_directory/good/$d" ] ; then
		tb_test -n "$d: Load config" false
		continue
	fi

	echo
	echo "---------  Test config $d  ---------"
	echo

	# load config; if error, quit
	tb_test -n "$d: Load config" -i load_config -d "good/$d" || continue

	# test usage errors
	test_t2b -c 1 "$d: History usage error" history &> /dev/null

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
