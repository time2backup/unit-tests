# Init: test if time2backup is there

# get time2backup path (first testbash dependency)
t2b_path=$tb_current_directory/../time2backup/time2backup
time2backup=$t2b_path/time2backup.sh
time2backup_cmd=()

# load libbash
source "$t2b_path"/libbash/libbash.sh - || return 1

# test if time2backup is loaded as dependency
tb_test -n "Test if time2backup is loaded" -r time2backup.sh basename "$time2backup" || return 1

curdir=$(dirname "$BASH_SOURCE")
config_directory=$curdir/config

# time2backup config version
config_version=1.6.2

# time2backup default options
console_mode=true
debug_mode=false
quiet_mode=true
