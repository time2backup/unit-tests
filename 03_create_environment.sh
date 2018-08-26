# Init: set environment

# tests directory (named with spaces, to test if compatible)
testdir=$(get_realpath "$curdir")/"t2b test files"

src=$testdir/src
dest=$testdir/dest

# create source directory
tb_test -n "Create source test directory" mkdir -p "$src" || return 1
# create backup destination
tb_test -n "Create destination test directory" mkdir -p "$dest" || return 1

# create source files
# details:
#   /
#     /dir1/
#       /subdir1/
#         /file1
#         /file2
#       /subdir2/
#         /file1
#         /file2
#     /dir2/
#       /subdir1/
#         /file1
#         /file2
#       /subdir2/
#         /file1
#         /file2

dir1=$src/dir1/
dir2=$src/dir2/

dir11=$dir1/subdir1/
mkdir -p "$dir11"

dir12=$dir1/subdir2/
mkdir -p "$dir12"

dir21=$dir2/subdir1/
mkdir -p "$dir21"

dir22=$dir2/subdir2/
mkdir -p "$dir22"

file111=$dir11/file1
echo "I am a file" > "$file111"
file112=$dir11/file2
echo "I am a file" > "$file112"

file121=$dir12/file1
echo "I am a file" > "$file121"
file122=$dir12/file2
echo "I am a file" > "$file122"

file211=$dir21/file1
echo "I am a file" > "$file211"
file212=$dir21/file2
echo "I am a file" > "$file212"

file221=$dir22/file1
echo "I am a file" > "$file221"
file222=$dir22/file2
echo "I am a file" > "$file222"

# hard link
ln "$src/file111" "$src/file111-hardlink"

# symlinks
ln -s "$src/dir1" "$src/dir1-symlink"
ln -s "$src/file111" "$src/file111-symlink"
