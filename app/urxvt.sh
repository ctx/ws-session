# open urxvt
# arg1: Data folder: where the last session was stored.
# Load the wd's from the file arg1/urxvt
s_urxvt_open_session() {
  s_restore_file $S_SHELL_HISTORY zdirs
  while read -r wd ;do
    s_run_cmd_opensession "urxvt -cd $wd"
  done < <(grep -v "^$" "$1"/urxvt)
}

# close urxvt, save working directory
# arg1: Temporary folder: this folder will be stored in the end.
# arg2: winids of all urxvts on current tag.
# Store the cwd of all urxvt's on the current tag in to the file arg1/urxvt
s_urxvt_close_session() {
  local temp_dir="$1"
  local urxvts="$2"

  for urxvt in $urxvts ; do
    local PID=$(xprop -id $urxvt _NET_WM_PID | cut -d " " -f 3 )
    ZSHPID=$(ps --ppid $PID | grep zsh | head -1 | awk '{print $1}' )
    local cwd=$(readlink /proc/$ZSHPID/cwd)
    [[ $cwd ]] && echo $cwd >> $temp_dir/urxvt
    xdotool windowkill --sync $urxvt
  done
}

# vim: ft=sh ts=2 et sw=2:

