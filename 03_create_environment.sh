# Init: set environment

# load libbash
source "$t2b_path"/libbash/libbash.sh - || return 1

# test if time2backup exists
tb_test -n "Test if time2backup is loaded" [ -f "$t2b_path/time2backup.sh" ] || return 1

curdir=$(dirname "$BASH_SOURCE")
config_directory=$curdir/config
testdir="$(lb_realpath "$curdir")/t2b test files"

# time2backup config version
config_version=1.9.0

# time2backup default options
console_mode=true
debug_mode=false
quiet_mode=true

src=$testdir/src
dest=$testdir/dest

# create source directory
tb_test -n "Create source test directory" mkdir -p "$src" || return 1
# create backup destination
tb_test -n "Create destination test directory" mkdir -p "$dest" || return 1
# create export destination
tb_test -n "Create export test directory" mkdir -p "$testdir"/dest2 || return 1

# create source files
#   /
#     /dir1/
#       /subdir1/
#         /file1
#         ...
#         /file9
#       ...
#       /subdir9/
#         /file1
#         ...
#         /file9
#     ...
#     /dir9/
#       /subdir1/
#         /file1
#         ...
#         /file9
#       ...
#       /subdir9/
#         /file1
#         ...
#         /file9
# variables:
#   $dir1: path to dir1
#   $dir11: path to subdir1 in dir1
#   $file111: path to file1 in subdir1 in dir1
#   ...
#   $file999: path to file9 in subdir9 in dir9

echo
echo "Create files..."

# create main directories
for d in $(seq 1 9) ; do
	dir=$src/dir$d
	eval dir$d=\"$dir\"

	# create subdirectories
	for s in $(seq 1 9) ; do
		subdir=$dir/subdir$s
		eval dir$d$s=\"$subdir\"

		mkdir -p "$subdir"

		# create files
		for f in $(seq 1 9) ; do
			file=$subdir/file$f
			eval file$d$s$f=\"$file\"

			echo "$file" > "$file"
		done
	done
done

# hard link
ln "$file111" "$src"/file111-hardlink

# symlinks
ln -s "$src"/dir1 "$src"/dir1-symlink
ln -s "$file111" "$src"/file111-symlink
