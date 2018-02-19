# Init: test if time2backup is there

# get time2backup path (first testbash dependency)
time2backup="$tb_current_directory/../time2backup/time2backup/time2backup.sh"
time2backup_cmd=()

# test if time2backup is loaded as dependency
tb_test -n "Test if time2backup is loaded" -r "time2backup.sh" basename "$time2backup"
if [ $? != 0 ] ; then
	return 1
fi

curdir=$(dirname "$BASH_SOURCE")
config_directory="$curdir/config"
