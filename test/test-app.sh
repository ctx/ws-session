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

app=$1
S_LIB_FOLDER="."
test_dir=/tmp/session-test
S_TEMP_FOLDER="$test_dir"
S_SEL_TAG=testtag
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
  for f in $@ ; do
    cp "$test_dir/old/$S_SEL_TAG/$f" "$tmp_dir"
  done
  unset f
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
  xprop WM_HINTS | awk '/window id/{print $NF}'
}

s_focus_window() {
  # No need to focus windows since xprop waits for a click.
  # There is a test for this function in the wm test.
  echo focus window >&2
}

mkdir -p "$tmp_dir"
mkdir "$test_dir/old"
type s_${app}_start

if [[ -n "$(type s_${app}_start | grep "function")" ]] ; then
  s_${app}_start $2
else
  ${app} $2 &
fi
started=yes
s_${app}_close_session $(select_window)
unset started
tree /tmp/session-test

sleep 2
mv "$tmp_dir" "$test_dir/old/" 
mkdir "$tmp_dir"
tree /tmp/session-test

s_${app}_open_session "$test_dir/old/$S_SEL_TAG"
started=yes

tree /tmp/session-test

testnumber=0
xdotool windowkill $(select_window)

s_cleanup

# vim: ft=sh ts=2 et sw=2:
