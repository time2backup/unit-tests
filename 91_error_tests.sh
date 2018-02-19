# run tests for bad configs

# parse every config
for dir in "$config_directory/bad/"* ; do

	# get directory name
	d=$(basename "$dir")

	# load config
	if ! [ -d "$config_directory/bad/$d" ] ; then
		tb_test -n "$d: Load config" false
		continue
	fi

	echo
	echo "---------  Test config $d  ---------"
	echo

	# load config; if error, quit
	tb_test -n "$d: Load config" -i load_config "bad/$d" || continue

	# run tests
	test_backup -c 6 $d
	test_restore -c 4 $d
	test_history -c 4 $d

	# clear backup files
	tb_test -n "$d: Clear backup files" rm -rf "$dest"/*
done

return 0
