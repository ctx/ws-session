# redirect output
# 1: normal output may be used by other scripts printed to stdout
# 2: stderr, some error messages get redirected to stderr
# 3: script errors only shown when debug mode is enabled or in the log
# 4: will be redirected to stderr

if [[ -n $S_LOGFILE ]] ; then
  (
  echo
  date
  echo -----------------------------
  ) > "$S_LOGFILE"
  exec 4>&2
  exec 2>>"$S_LOGFILE"
  exec 3>>"$S_LOGFILE"
  set -xv
elif [[ -n $S_DEBUG || $1 == "debug" || $1 == "print" ]] ; then
  exec 3>&2
  exec 4>&2
else
  exec 3>/dev/null
  exec 4>&2
fi

# error handling functions
s_fatal() {
  echo -e "FATAL: ${1}, aborting!" >&4
  if [[ $2 == "help" ]] ; then
    echo >&4
    s_help >&4
  elif [[ -n $2 ]] ; then
    echo -e "       ${2}." >&4
  fi
  exit 127
}

s_error() {
  echo -e "ERROR: ${1}!" >&4
  if [[ $2 == "help" ]] ; then
    echo >&4
    s_help >&4
  elif [[ -n $2 ]] ; then
    echo -e "       ${2}." >&4
  fi
}

# set default settings
if [[ -d "$XDG_DATA_HOME" ]] ; then
  S_DATA_HOME="${S_DATA_HOME:-$XDG_DATA_HOME/ws-session}"
else
  S_DATA_HOME="${S_DATA_HOME:-$HOME/.ws-session/sessions}"
fi
if [[ -d "$XDG_CONFIG_HOME" ]] ; then
  S_CONFIG_HOME="${S_CONFIG_HOME:-$XDG_CONFIG_HOME/ws-session}"
else
  S_CONFIG_HOME="${S_CONFIG_HOME:-$HOME/.ws-session}"
fi
S_TMP_DIR="${S_TMP_DIR:-/tmp/ws-session-$(whoami)}"

S_NUMBER_OF_BACKUPS="5"
S_LOAD_LAYOUT_SLEEP=1
S_RUN_ACTION_SLEEP=1
S_BLACKLIST=

# load user settings
if [[ -f "$S_CONFIG_HOME/ws-session.rc" ]] ; then
  source "$S_CONFIG_HOME/ws-session.rc" 2>&3 \
    || s_fatal "syntax error in .ws-session.rc, use bash syntax"
elif [[ -f "$HOME/.ws-session.rc" ]] ; then
  source "$HOME/.ws-session.rc" 2>&3 \
    || s_fatal "syntax error in .ws-session.rc, use bash syntax"
else
  s_error "ws-session.rc not found" \
    "install it to '$HOME/.ws-session.rc'
       or '\$XDG_CONFIG_HOME/ws-session/ws-session.rc'.
       Continuing with default settings"
fi

# declare functions to source core and app files
s_source() {
  if [[ -f "$S_CONFIG_HOME/$1" ]] ; then
    source "$S_CONFIG_HOME/$1" 2>&3 \
      || s_fatal "syntax error in $S_CONFIG_HOME/$1, fix it"
  elif [[ -f "$S_LIB_HOME/$1" ]] ; then
    source "$S_LIB_HOME/$1" 2>&3 \
      || s_fatal "syntax error in $S_LIB_HOME/$1, please report at
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
        if [[ -f "$S_LIB_HOME/core/${a}.sh" ]] ; then
          source "$S_LIB_HOME/core/${a}.sh" 2>&3 \
            || s_fatal "syntax error in $S_LIB_HOME/core/${a}.sh, please report at
    <http://github.com/ctx/ws-session/issues>"
        else
          s_fatal "no such file $S_LIB_HOME/core/${a}.sh" \
            "something is wrong with your installation"
        fi
    esac
  done
}

# vim: ft=sh ts=2 et sw=2:

