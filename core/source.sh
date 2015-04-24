# at the very beginnig declare the error handling functions
s_fatal() {
  echo -e "FATAL: ${1}, aborting!" >&2
  if [[ $2 == "help" ]] ; then
    s_help >&2
  elif [[ -n $2 ]] ; then
    echo -e "       ${2}." >&2
  fi
  exit 1
}

s_error() {
  echo -e "ERROR: ${1}!" >&2
  if [[ $2 == "help" ]] ; then
    s_help >&2
  elif [[ -n $2 ]] ; then
    echo -e "       ${2}." >&2
  fi
}

# set default settings
if [[ -d "$XDG_DATA_HOME" ]] ; then
  S_DATA_FOLDER="${S_DATA_FOLDER:-$XDG_DATA_HOME/ws-session}"
else
  S_DATA_FOLDER="${S_DATA_FOLDER:-$HOME/.ws-session/sessions}"
fi
if [[ -d "$XDG_CONFIG_HOME" ]] ; then
  S_CONFIG_FOLDER="${S_CONFIG_FOLDER:-$XDG_CONFIG_HOME/ws-session}"
else
  S_CONFIG_FOLDER="${S_CONFIG_FOLDER:-$HOME/.ws-session}"
fi
S_TEMP_FOLDER="${S_TEMP_FOLDER:-/tmp/ws-session-$(whoami)}"

S_NUMBER_OF_BACKUPS="5"
S_LOAD_LAYOUT_SLEEP=1
S_RUN_ACTION_SLEEP=1
S_BLACKLIST=

# load user settings
source "$HOME/.ws-session.rc" 2>/dev/null \
  || source "$S_CONFIG_FOLDER/ws-session.rc" 2>/dev/null \
  || s_error "ws-session.rc not found" \
    "install it to '$HOME/.ws-session.rc'
       or '\$XDG_CONFIG_HOME/ws-session/ws-session.rc'.
       Continuing with default settings"

# declare functions to source core and app files
s_source() {
  source "$S_CONFIG_FOLDER/$1" 2>/dev/null \
    || source "$S_LIB_FOLDER/$1" 2>/dev/null \
    || s_fatal "'$1' not found" "Fix your installation"
}

s_source_lib() {
  for a in $@ ; do
    case $a in
      stopwm)
        [[ -z $S_WM ]] && s_fatal "No supported wm is running"
        ;;
      allapp)
        for app in ${S_APPLICATIONS[@]} ; do
          s_source app/$app.sh
        done
        ;;
      *)
        source "$S_LIB_FOLDER/core/${a}.sh" \
          || s_fatal "no such file $S_LIB_FOLDER/core/${a}.sh" \
                     "something is wrong with your installation"
    esac
  done
}

# vim: ft=sh ts=2 et sw=2:

