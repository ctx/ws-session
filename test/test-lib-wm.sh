#!/bin/bash

s_assert_equals() {
  if [[ "$1" == "$2" ]] ; then
    echo -n "$3; "
  else
    echo $3 failed;
    echo $1 not equals $2
    exit 1
  fi
}

S_ROOT_FOLDER="."
source ./lib/source.sh
S_DEFAULT_TAG=session
source ./lib/wm.sh

echo "#### Running wm tests: "
echo -n "##   "

# test 1 ----------------------------------------------------------------------
# test seltag stupid
tag="$(s_seltag)"

s_assert_equals "$tag" "$S_DEFAULT_TAG" test1

# test 2 ----------------------------------------------------------------------
# create and change to tag newtag 
tag="tagname"
s_newtag $tag

s_assert_equals "$(s_seltag)" "$tag" test2

# test 3 ---------------------------------------------------------------------
# close newtag and go to tag 1 per default
S_SEL_TAG=$(s_seltag)
s_closetag
s_assert_equals "$(s_seltag)" "$S_DEFAULT_TAG" test3


# test 4 ---------------------------------------------------------------------
s_newtag
s_assert_equals "$(s_seltag)" "$S_DEFAULT_TAG" test4

# test 5 ---------------------------------------------------------------------
echo
echo
echo test 5:
echo This should be a list of your open windows on the current tag.
echo "id         class"
S_SEL_TAG=$(s_seltag)
s_list_app_seltag

# test 6 ---------------------------------------------------------------------
echo
echo test 6:
echo WAIT: every window on the current tag should get focus once.
S_SEL_TAG=$(s_seltag)
for app in $(s_list_app_seltag | cut -f1 -d" ") ; do
  s_focus_window $app
  sleep 1
done

# test 7 ---------------------------------------------------------------------
echo
echo test 7:
echo This should be a list of all your open tags:
S_SEL_TAG=$(s_seltag)
s_list_open_tags

echo
echo "##   All tests passed!"
echo

exit 0

# vim: ft=sh ts=2 et sw=2:
