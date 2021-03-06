#!/bin/bash

# setup ==================================================================
# override some settings
S_LIB_HOME="."
S_DEBUG=1
source $S_LIB_HOME/conf/ws-session.rc
S_NUMBER_OF_BACKUPS=3
test_dir="/tmp/session-test"
S_DATA_HOME="$test_dir/session"
mkdir -p "$S_DATA_HOME"
source ./core/data.sh

# functions ==============================================================
# remove test data
s_cleanup() {
  echo -n "##   cleanup"
  rm -rf "$test_dir"

  ! [[ -d $test_dir ]] && \
    echo " .. done."
  echo "##----------------------------------"
}

# in this tests we compare the directory $test_dir/$dir (sample) with the
# directory $test_dir/session (test data).
s_assert_data_dir() {
  local dir="$1"
  err="$(diff -qr $test_dir/{$dir,session} 2>&1)"
  if [[ -z "$err" ]]; then
    echo -n "$dir; "
  else
    echo $dir failed;
    echo "$err"
    s_cleanup
    exit 1
  fi
}

# start ==================================================================
echo "#### Running data tests: -----------"
echo -n "##   "

# test 0 -----------------------------------------------------------------
# update sample
mkdir $test_dir/test0

# check
s_assert_data_dir test0

# test 1 -----------------------------------------------------------------
# make 6 backups of a dir with a file named app-$i
test_data="$test_dir/data"
for ((test=0; test<=5; test++ )); do
  mkdir -p $test_data/test
  touch $test_data/test/app-$test 
  s_store_data $test_data/test test
done

# update sample
mkdir -p $test_dir/test1/test-{1,2,3}
touch $test_dir/test1/{test-1/app-5,test-2/app-4,test-3/app-3}

# check
s_assert_data_dir test1

# test 2 -----------------------------------------------------------------
# restore last backup
s_restore_data test

# update sample
mkdir -p $test_dir/test2/test-{1,2,$restored-1}
touch $test_dir/test2/{test-1/app-4,test-2/app-3,test-$restored-1/app-5}

# check
s_assert_data_dir test2 

# test 3 -----------------------------------------------------------------
# restore the backup of the previous restore function
s_restore_selected_data test-$restored-1 test

# update sample
cp -r $test_dir/test1 $test_dir/test3

# check
s_assert_data_dir test3

# test 4 ----------------------------------------------------------------
# restore 7 times
for ((j=0; j<=7; j++)); do
  s_restore_data test
done

# update sample
mkdir -p $test_dir/test4/test-{1,$restored-1,$restored-2}
touch $test_dir/test4/{test-$restored-2/app-5,test-$restored-1/app-4,test-1/app-3}

# check
s_assert_data_dir test4

# test 5 -----------------------------------------------------------------
# run all functions without arguments
s_rotate_data
s_store_data
s_restore_data
s_restore_selected_data
s_delete_all_backups

# update sample
cp -r $test_dir/{test4,test5}

# check
s_assert_data_dir test5

# test 6 -----------------------------------------------------------------
# run all functions with crazy arguments
s_rotate_data thomas sali dui franz
s_store_data peter xafer thomas kurt
s_restore_data annemarie regula karin petra
s_restore_selected_data blah dui dui ahla
s_delete_all_backups sali dui franz

# update sample
cp -r $test_dir/{test4,test6}

# check
s_assert_data_dir test6

# test 7 -----------------------------------------------------------------
# create data to delete
for ((test=0; test<=5; test++ )); do
  mkdir -p $test_data/test-1
  touch $test_data/test-1/app-$test 
  s_store_data $test_data/test-1 test-1
done
# delete all backups of 'test'
s_delete_all_backups test-1

# update sample
cp -r $test_dir/{test4,test7}
mkdir $test_dir/test7/test-1-1
touch $test_dir/test7/test-1-1/app-5

# check
s_assert_data_dir test7

# end ====================================================================
echo
echo "##   All tests passed!"
s_cleanup

exit 0

# vim: ft=sh ts=2 et sw=2:
