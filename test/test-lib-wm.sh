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
s_source_rc
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
echo test 5:
echo This should be a list of your open windows on the current tag.
echo "id         class"
S_SEL_TAG=$(s_seltag)
s_list_app_seltag

echo
echo "##   All tests passed!"

exit 0

# vim: ft=sh ts=2 et sw=2:
