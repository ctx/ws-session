quteb=qutebrowser

s_help_qutebrowser() {
  echo 'About ws-session app files: qutebrowser

Description:
    This wrapper uses different basedirs to isolate sessions.
    qutebrowser --basedir /path/to/temp/$session/qutebrowser
    The default config will be linked to this basedir.

Usage:
    Use the ws-app wrapper to start qutebrowser.

Configuration:
    link ws-app to $PATH/qutebrowser eg:
    ln /usr/bin/ws-app $HOME/.config/ws-session/bin/qutebrowser

  '
}

s_qutebrowser_open_session() {
  if [[ -d $1/$quteb ]] ; then
    if [[ ! -d $tmp_dir/$quteb ]] ; then
      cp -a "$1/$quteb" "$tmp_dir"
    fi
    /usr/bin/$quteb --basedir "$tmp_dir/$quteb/" >&3 2>&3 &
    s_reg_winid "$!" "$(< $tmp_dir/$quteb/winid)"
  fi
}

s_qutebrowser_close_session() {
  echo "$1" > "$tmp_dir/$quteb/winid"
  /usr/bin/$quteb --basedir "$tmp_dir/$quteb/" :wq >&3 2>&3
}

s_qutebrowser_start() {
  local tmp_dir="$S_TMP_DIR/$S_SEL_TAG"
  mkdir "$tmp_dir/$quteb"
  ln -s "$XDG_CONFIG_HOME/qutebrowser" "$tmp_dir/$quteb/config"
  /usr/bin/$quteb --basedir "$tmp_dir/$quteb/" >&3 2>&3 &
}

# vim: ft=sh ts=2 et sw=2:
