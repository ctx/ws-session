# set defaults
S_DATA_FOLDER="$XDG_DATA_HOME/ws-session"
S_TEMP_FOLDER="/tmp/ws-session-$(whoami)"
S_CONFIG_FOLDER="$XDG_CONFIG_HOME/ws-session"
S_NUMBER_OF_BACKUPS="5"

if [[ -f $HOME/.ws-session.rc ]] ; then
  source $HOME/.ws-session.rc
elif [[ -f $HOME/.config/ws-session/ws-session.rc ]] ; then
  source $HOME/.config/ws-session/ws-session.rc
else
  echo Error session.rc not found!
  echo install it to $HOME/.ws-session.rc or $XDG_COFIG_HOME/ws-session/ws-session.rc
fi

s_source() {
  if [[ -f "$S_CONFIG_FOLDER/$1" ]] ; then
    source "$S_CONFIG_FOLDER/$1"
  elif [[ -f "$S_ROOT_FOLDER/$1" ]] ; then
    source "$S_ROOT_FOLDER/$1"
  else
    echo ERROR: $1 not found
    exit 1
  fi
}

s_source_lib() {
  for a in $@ ; do
    case $a in
      stopwm)
        s_stop_if_no_wm
        ;;
      allapp)
        for app in ${S_APPLICATIONS[@]} ; do
          s_source app/$app.sh
        done
        ;;
      *)
        source "$S_ROOT_FOLDER/lib/${a}.sh"
    esac
  done
}

s_run_cmd_opensession() {
  local cmd="$1"
  $cmd > /dev/null 2>&1 & disown
}

s_run_cmd() {
  local cmd="$1"
  #$cmd > /dev/null 2>&1 & disown
  $cmd 2>&1 & disown
}

# vim: ft=sh ts=2 et sw=2:

