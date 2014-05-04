# set defaults
S_DATA_FOLDER="$XDG_DATA_HOME/ws-session"
S_TEMP_FOLDER="/tmp/ws-session-$(whoami)"
S_CONFIG_FOLDER="$XDG_CONFIG_HOME/ws-session"
S_NUMBER_OF_BACKUPS="5"
S_LOAD_LAYOUT_SLEEP=1
S_BLACKLIST=

s_fatal() {
  echo -e "FATAL: ${1}, aborting!"
  if [[ $2 == "help" ]] ; then
    s_help
  elif [[ -n $2 ]] ; then
    echo -e "Hint:  ${2}."
  fi
  exit 1
}

s_error() {
  echo -e "ERROR: ${1}!"
  if [[ $2 == "help" ]] ; then
    s_help
  elif [[ -n $2 ]] ; then
    echo -e "Hint:  ${2}."
  fi
}

if [[ -f $HOME/.ws-session.rc ]] ; then
  source "$HOME/.ws-session.rc"
elif [[ -f $HOME/.config/ws-session/ws-session.rc ]] ; then
  source "$HOME/.config/ws-session/ws-session.rc"
else
  s_error "session.rc not found" \
    "install it to $HOME/.ws-session.rc
       or $XDG_CONFIG_HOME/ws-session/ws-session.rc.
       Continuing with default settings"
fi

s_source() {
  if [[ -f "$S_CONFIG_FOLDER/$1" ]] ; then
    source "$S_CONFIG_FOLDER/$1"
  elif [[ -f "$S_LIB_FOLDER/$1" ]] ; then
    source "$S_LIB_FOLDER/$1"
  else
    s_fatal "'$1' not found" "Fix your installation"
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
        source "$S_LIB_FOLDER/lib/${a}.sh"
    esac
  done
}

# vim: ft=sh ts=2 et sw=2:

