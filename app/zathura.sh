s_help_zathura(){
  echo 'About ws-session app files: zathura

Description:
    This app file reads the file name from the _NET_WM_NAME
    atom to store the names of the open files in SESSIONDIR/zathura.

Usage:
    Start zathura normally.

Configuration:
    In the zathura config you have to adjust this two settings:
    set window-title-basename false
    set statusbar-basename false

Dependencies:
    xprop
    xdotool

Todo:
    Create a version which puts all zathura windows in one
    tabbed instance.
  '
}

# $1: directory with data from the last session
s_zathura_open_session() {
  local file="$1/zathura"
  if [[ -f $file ]] ;then 
    while read -r id document ; do
      if [[ -n $id ]] ; then
        /usr/bin/zathura "$document" >&3 2>&3 &
        s_reg_winid $! $id
      fi
    done <"$file"
    unset id document
  fi
}

# $1: windowids of all running zathuras
# create a file containing lines: 0xoldwinid /path/to some/file.pdf
s_zathura_close_session() {
  local file="$tmp_dir/zathura"
  local winids="$1"
  echo -n > "$file"

  for id in $winids ;  do
    echo -n "$id " >> "$file"
    xprop _NET_WM_NAME -id $id \
      | sed 's/^_NET_WM_NAME(UTF8_STRING) = \"//
             s/\"$//' >> "$file"
    xdotool windowkill $id
  done
  unset id
}

# vim: ft=sh ts=2 et sw=2:
