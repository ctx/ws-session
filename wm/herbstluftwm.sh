s_seltag_herbstluftwm() {
  herbstclient tag_status \
    | awk 'match($0,/#[^\t]*/) { print substr($0,RSTART+1,RLENGTH-1) }'
}

s_list_app_seltag_herbstluftwm() {
  herbstclient stack \
    | awk '/Client 0x/{ print $5 }' \
    | while read -r client ; do
    s_print_id_class $client
  done | sort -u
  unset client
}

s_list_open_tags_herbstluftwm() {
  herbstclient attr tags.by-name. | awk '/^ /{ gsub(".$",""); print $1 }'
}

s_newtag_herbstluftwm() {
  if ! grep -q -F "$@" < <(s_list_open_tags_herbstluftwm) ; then 
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
