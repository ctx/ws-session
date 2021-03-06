#!/bin/bash

s_assert_equals() {
  testnumber=$((testnumber+1))
  if [[ "$1" == "$2" ]] ; then
    echo -n "test$testnumber; "
  else
    echo test$testnumber failed;
    echo "$1 not equals $2"
    exit 1
  fi
}

s_cleanup() {
  echo -n "##   cleanup"
  rm -rf "$test_dir"

  ! [[ -d $test_dir ]] && \
    echo " .. done."
  echo "##----------------------------------"
}

s_seltag() {
  s_seltag_$S_WM
}

exec 3>&2
exec 4>&1

S_LIB_HOME="."
source ./core/source.sh
source ./core/wm.sh
test_dir=/tmp/session-test
S_DEBUG=1
S_TMP_DIR=$test_dir/tmp
S_DEFAULT_TAG=${TEST_TAG:-1}
echo "use 'TEST_TAG=yourfocusedtag test/test-core-wm.sh' if you are not on tag 1"

testnumber=0

echo "#### Running wm tests: -------------"
echo -n "##   "

# test seltag ------------------------------------------------------------
# lame, but ...
tag="$(s_seltag)"
s_assert_equals "$tag" "$S_DEFAULT_TAG"

# test create tag --------------------------------------------------------
# create and change to tag newtag 
tag="tagname"
s_newtag $tag
s_assert_equals "$(s_seltag)" "$tag"

# test close tag ---------------------------------------------------------
# close newtag and go to tag 1 per default
S_SEL_TAG=$(s_seltag)
s_closetag
s_assert_equals "$(s_seltag)" "$S_DEFAULT_TAG"


# test newtag no name ----------------------------------------------------
# try to change to tag "" should do nothing
s_newtag
s_assert_equals "$(s_seltag)" "$S_DEFAULT_TAG"

# test tag name with special chars ---------------------------------------
# the tag with name ~!@~`#$%^&*()_+="-0\][{}|;':,/.<>
#crazyname='~!@~`#$%^&*()_+="-0][{}|;'\'':,/.<>'
crazyname='~!@~`#$%-0:.'
s_newtag "$crazyname"
S_SEL_TAG=$(s_seltag)
s_assert_equals "$S_SEL_TAG" "$crazyname"
mkdir -p "$test_dir/tmp/$crazyname"
if ! [[ -d $S_TMP_DIR/$crazyname ]] ; then
  ls -l "$S_TMP_DIR"
fi
s_closetag

# test focus window ------------------------------------------------------
# focus every window on the default tag
S_SEL_TAG=$(s_seltag)
for app in $(s_list_app_seltag | cut -f1 -d" ") ; do
  s_focus_window $app || exit 1
done


echo
echo "##   All tests passed!"

# test list app seltag ---------------------------------------------------
# cannot compare with a function 
echo
echo
echo Looks good but we have to compare the following output with the reality:
echo
echo This should be a list of your open windows on the current tag:
echo "id         class"
S_SEL_TAG=$(s_seltag)
s_list_app_seltag
echo
echo This should be a list of your open tags line by line:
s_list_open_tags
echo
echo test the layout: run the function and cat the file
mkdir -p "$S_TMP_DIR/$S_SEL_TAG"
s_save_layout "$S_TMP_DIR/$S_SEL_TAG"
cat "$S_TMP_DIR/$S_SEL_TAG"/*.layout
echo

s_cleanup

exit 0

# vim: ft=sh ts=2 et sw=2:
