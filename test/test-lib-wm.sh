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

S_LIB_FOLDER="."
source ./lib/source.sh
S_DEFAULT_TAG=session
source ./lib/wm.sh
test_dir=/tmp/session-test
S_TEMP_FOLDER=$test_dir/tmp

testnumber=0

echo "#### Running wm tests: -------------"
echo -n "##   "

# test seltag ----------------------------------------------------------------------
# lame, but ...
tag="$(s_seltag)"
s_assert_equals "$tag" "$S_DEFAULT_TAG"

# test create tag ----------------------------------------------------------------------
# create and change to tag newtag 
tag="tagname"
s_newtag $tag
s_assert_equals "$(s_seltag)" "$tag"

# test close tag ---------------------------------------------------------------------
# close newtag and go to tag 1 per default
s_closetag
s_assert_equals "$(s_seltag)" "$S_DEFAULT_TAG"


# test newtag no name ---------------------------------------------------------------------
# try to change to tag "" should do nothing
s_newtag
s_assert_equals "$(s_seltag)" "$S_DEFAULT_TAG"

# test tag name with special chars ---------------------------------------------------------------------
# the tag with name ~!@~`#$%^&*()_+="-0\][{}|;':,/.<>
crazyname='~!@~`#$%^&*()_+="-0][{}|;'\'':,/.<>'
s_newtag "$crazyname"
S_SEL_TAG=$(s_seltag)
s_assert_equals "$S_SEL_TAG" "$crazyname"
mkdir -p "$test_dir/tmp/$crazyname"
if ! [[ -d $S_TEMP_FOLDER/$crazyname ]] ; then 
  ls -l "$S_TEMP_FOLDER"
fi
s_closetag

# test focus window ---------------------------------------------------------------------
# focus every window on the default tag
S_SEL_TAG=$(s_seltag)
for app in $(s_list_app_seltag | cut -f1 -d" ") ; do
  s_focus_window $app || exit 1
done

echo
echo "##   All tests passed!"

s_cleanup
# test list app seltag ---------------------------------------------------------------------
# cannot compare 
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



exit 0

# vim: ft=sh ts=2 et sw=2:
