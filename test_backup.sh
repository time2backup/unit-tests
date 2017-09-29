# test bakup/restore

for dir in "$config_directory/"* ; do

	d=$(basename "$dir")

	if ! [ -d "$config_directory/$d" ] ; then
		continue
	fi

	echo -e "\n------------\nTesting $d...\n"

	tb_test -i load_config "$d"
	if [ $? != 0 ] ; then
		continue
	fi

	test_t2b "$d: Backup" backup

	file111_checksum=$(file_checksum "$file111")

	echo newcontent > "$file111"
	tb_test -n "$d: Update file111" [ $? == 0 ]

	test_t2b "$d: Restore file111" restore -f "$file111"

	test_file "$file111_checksum" "$file111"
done

return 0
