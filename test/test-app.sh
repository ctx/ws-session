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
  echo "##   cleanup"

  xdotool windowkill $(select_window)
  rm -rf "$test_dir"

  ! [[ -d $test_dir ]] && echo "##   done."
  echo "##----------------------------------"
}

app=$1
S_LIB_FOLDER="."
test_dir="/tmp/session-test"
export S_TEMP_FOLDER="$test_dir"
export S_SEL_TAG=testtag
S_SHELL_FILES=( zsh_history )
tmp_dir="$S_TEMP_FOLDER/$S_SEL_TAG"
S_TERM=urxvt
TERM=
if [[ -z $app ]] ;then
        echo -e "Usage:"
        echo -e "$0 [app]"
        echo -e "apps: $(ls $S_LIB_FOLDER/app | sed 's/\.sh//g' | tr '\n' ' ')"
        exit 1
fi
source ./app/${app}.sh

# Mock functions
s_restore_file() {
  local f
  for f in $@ ; do
    cp "$test_dir/old/$S_SEL_TAG/$f" "$tmp_dir"
  done
}

s_list_app_seltag() {
  if [[ -n $started ]] ; then
    echo $app $(select_window)
  else
    echo -n
  fi
}
s_reg_winid() {
  echo PID/WINID: $@
}

select_window() {
  xwininfo -children | awk '/Window id/{print $4}'
}

s_focus_window() {
  # No need to focus windows since xprop waits for a click.
  # There is a test for this function in the wm test.
  echo focus window >&2
}

mkdir -p "$tmp_dir"
mkdir "$test_dir/old"

if type s_${app}_start 2>/dev/null | grep -q function ; then
  s_${app}_start $2 &
else
  PATH="$PWD/${0%/*}/mock:$PATH"
  ${app} $2 &
fi
started=yes
s_${app}_close_session $(select_window)
unset started
echo "## started $app on $S_SEL_TAG"
tree /tmp/session-test

sleep 2
echo "## close session"
mv "$tmp_dir" "$test_dir/old/" 
tree /tmp/session-test

echo "## open session"
mkdir "$tmp_dir"
s_${app}_open_session "$test_dir/old/$S_SEL_TAG"
started=yes

tree /tmp/session-test

testnumber=0

s_cleanup

# vim: ft=sh ts=2 et sw=2:
