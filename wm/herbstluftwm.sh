s_help_herbstluftwm() {
  echo 'About ws-session wm files: herbstluftwm

Description:
    This wrapper uses herbstclient to communicate with herbstluftwm.

Configuration:
    No configuration is needed.

Dependencies:
    xdotool
    '
}

s_seltag_herbstluftwm() {
  herbstclient attr tags.focus.name
}

s_list_app_seltag_herbstluftwm() {
  herbstclient dump \
    | grep -oP "\b0x.*?\b" \
    | sort -u \
    | while read -r client ; do
      s_print_id_class $client
    done
  unset client
}

s_list_open_tags_herbstluftwm() {
  herbstclient complete 1 use
}

s_newtag_herbstluftwm() {
  if ! s_list_open_tags_herbstluftwm | grep -q -x -e "$@" ; then 
    herbstclient chain , add "$@" , use "$@"
  else
    herbstclient use "$@"
  fi
}

s_closetag_herbstluftwm() {
  herbstclient chain , \
    use "$S_DEFAULT_TAG" , \
    merge_tag "$S_SEL_TAG" "$S_DEFAULT_TAG"
}

s_focus_window_herbstluftwm() {
  xdotool windowactivate --sync "$@"
}

S_WM_SUPPORTS_LAYOUT_SAVING="1"

s_save_layout_herbstluftwm() {
  herbstclient dump
}

s_reload_layout_herbstluftwm() {
  herbstclient load "$(< "$1")"
}

# vim: ft=sh ts=2 et sw=2:
