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
S_LIB_HOME="."
S_DEBUG=1
test_dir="/tmp/session-test"
export S_TMP_DIR="$test_dir"
export S_SEL_TAG=testtag
S_SHELL_FILES=( zsh_history )
tmp_dir="$S_TMP_DIR/$S_SEL_TAG"
S_TERM=urxvt
TERM=
if [[ -z $app ]] ;then
        echo -e "Usage:"
        echo -e "$0 [app]"
        echo -e "apps: $(ls $S_LIB_HOME/app | sed '/command/d;s/\.sh//g' | tr '\n' ' ')"
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

s_tree() {
  tree -L 3 "$test_dir/old/$S_SEL_TAG/"
  tree -L 3 "$tmp_dir"
}

mkdir -p "$tmp_dir"
mkdir "$test_dir/old"

if type s_${app}_open_session 2>/dev/null | grep -q function ; then
  s_${app}_open_session
fi
echo "## open empty session should do nothing"
echo "## close it otherwise and stop here"

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
s_tree

sleep 2
echo "## close session"
mv "$tmp_dir" "$test_dir/old/" 
s_tree

echo "## open session"
mkdir "$tmp_dir"
s_${app}_open_session "$test_dir/old/$S_SEL_TAG"
started=yes

s_tree

testnumber=0

s_cleanup

# vim: ft=sh ts=2 et sw=2:
