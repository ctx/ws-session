# at the very beginnig declare the error handling functions
s_fatal() {
  echo -e "FATAL: ${1}, aborting!" >&2
  if [[ $2 == "help" ]] ; then
    echo >&2
    s_help >&2
  elif [[ -n $2 ]] ; then
    echo -e "       ${2}." >&2
  fi
  exit 127
}

s_error() {
  echo -e "ERROR: ${1}!" >&2
  if [[ $2 == "help" ]] ; then
    echo >&2
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
if [[ -f "$HOME/.ws-session.rc" ]] ; then
  source "$HOME/.ws-session.rc" >&3 2>&3 \
    || s_fatal "syntax error in .ws-session.rc, use bash syntax"
elif [[ -f "$S_CONFIG_FOLDER/ws-session.rc" ]] ; then
  source "$S_CONFIG_FOLDER/ws-session.rc" >&3 2>&3 \
    || s_fatal "syntax error in .ws-session.rc, use bash syntax"
else
  s_error "ws-session.rc not found" \
    "install it to '$HOME/.ws-session.rc'
       or '\$XDG_CONFIG_HOME/ws-session/ws-session.rc'.
       Continuing with default settings"
fi

# declare functions to source core and app files
s_source() {
  if [[ -f "$S_CONFIG_FOLDER/$1" ]] ; then
    source "$S_CONFIG_FOLDER/$1" >&3 2>&3 \
      || s_fatal "syntax error in $S_CONFIG_FOLDER/$1, fix it"
  elif [[ -f "$S_LIB_FOLDER/$1" ]] ; then
    source "$S_LIB_FOLDER/$1" >&3 2>&3 \
      || s_fatal "syntax error in $S_LIB_FOLDER/$1, please report at
    <http://github.com/ctx/ws-session/issues>"
  else
    s_fatal "'$1' not found" "Fix your installation"
  fi
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
        if [[ -f "$S_LIB_FOLDER/core/${a}.sh" ]] ; then
          source "$S_LIB_FOLDER/core/${a}.sh" >&3 2>&3 \
            || s_fatal "syntax error in $S_LIB_FOLDER/core/${a}.sh, please report at
    <http://github.com/ctx/ws-session/issues>"
        else
          s_fatal "no such file $S_LIB_FOLDER/core/${a}.sh" \
            "something is wrong with your installation"
        fi
    esac
  done
}

# vim: ft=sh ts=2 et sw=2:

