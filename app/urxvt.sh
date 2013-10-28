# open urxvt
# arg1: Data folder: where the last session was stored.
# Load the wd's from the file arg1/urxvt
s_urxvt_open_session() {
  while read wd ;do
    urxvt -cd $wd > /dev/null 2>&1 & disown
  done < <(cat "$1"/urxvt | grep -v "^$" )
}

# close urxvt, save working directory
# arg1: Temporary folder: this folder will be stored in the end.
# arg2: winids of all urxvts on current tag.
# Store the cwd of all urxvt's on the current tag in to the file arg1/urxvt
s_urxvt_close_session() {
  local temp_dir="$1"
  local urxvts="$2"

  if [[ $urxvts ]] ; then 
    echo -n > $temp_dir/urxvt
  fi

  for urxvt in $urxvts ; do
    local PID=$(xprop -id $urxvt | grep -m 1 PID | cut -d " " -f 3 )
    #[[ -z $PID ]] && local PID=$(( $(xprop -id $urxvt | grep -m 1 PID | cut -d " " -f 3 ) + 3 ))
    ZSHPID=$(ps --ppid $PID | grep zsh | head -1 | awk '{print $1}' )
    local cwd=$(readlink /proc/$ZSHPID/cwd)
    [[ $cwd ]] && echo $cwd >> $temp_dir/urxvt
  done
}

# vim: ft=sh ts=2 et sw=2:

