quteb=qutebrowser

s_qutebrowser_open_session() {
  cp -R "$1/$quteb" "$tmp_dir"
  /usr/bin/$quteb --basedir "$tmp_dir/$quteb/" >/dev/null 2>&1 &
  s_reg_winid "$!" "$(< $tmp_dir/$quteb/winid)"
}

s_qutebrowser_close_session() {
  echo "$1" > "$tmp_dir/$quteb/winid"
  /usr/bin/$quteb --basedir "$tmp_dir/$quteb/" :wq >/dev/null 2>&1 &
}

s_qutebrowser_start() {
  local tmp_dir="$S_TMP_DIR/$S_SEL_TAG"
  mkdir "$tmp_dir/$quteb"
  ln -s "$XDG_CONFIG_HOME/qutebrowser" "$tmp_dir/$quteb/config"
  /usr/bin/$quteb --basedir "$tmp_dir/$quteb/" > /dev/null 2>&1 &
}

# vim: ft=sh ts=2 et sw=2:
