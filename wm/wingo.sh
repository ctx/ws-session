s_seltag_wingo() {
  wingo-cmd GetWorkspace
}

s_newtag_wingo() {
  if ! grep -q -F "$@" < <(s_list_open_tags_wingo) ; then
    wingo-cmd "AddWorkspace \"$@\"" > /dev/null
  fi
  wingo-cmd "Workspace \"$@\"" > /dev/null
}

s_closetag_wingo() {
  wingo-cmd "Workspace \"$S_DEFAULT_TAG\"" > /dev/null
  wingo-cmd "RemoveWorkspace \"$S_SEL_TAG\"" > /dev/null
}

s_list_open_tags_wingo() {
  wingo-cmd GetWorkspaceList
}

s_list_app_seltag_wingo() {
  for client in $(wingo-cmd 'GetClientList (GetWorkspace)') ; do
    client="0x$(echo "ibase=10;obase=16;$client"|bc)"
    echo -n "$client "
    xprop -id $client WM_CLASS | sed 's/^.* = \"//;s/\", \".*$//;s/\"$//'
  done
  unset client
}

s_focus_window_wingo() {
  xdotool windowactivate --sync "$@"
  #wingo-cmd "Focus \"$@\""
}

S_WM_SUPPORTS_LAYOUT_SAVING="0"

# vim: ft=sh ts=2 et sw=2:
