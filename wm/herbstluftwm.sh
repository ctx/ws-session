s_seltag_herbstluftwm() {
  herbstclient tag_status \
    | tr '\t' '\n' \
    | grep -e "^#" \
    | cut -c2-
}

s_list_app_seltag_herbstluftwm() {
  while read -r client ; do
    class=$(xprop -id $client WM_CLASS | sed 's/^.* = \"//;s/\", \".*$//;s/\"$//')
    echo "$client $class"
  done < <(herbstclient stack \
    | grep "Client 0x" \
    | sed 's/^.*Client //' \
    | cut -f1 -d" " \
    | sort -u)
}

s_list_open_tags_herbstluftwm() {
  herbstclient tag_status \
    | tr '\t' '\n' \
    | cut -c2- \
    | grep -v "^$"
}

s_newtag_herbstluftwm() {
  [[ -z "$(s_list_open_tags_herbstluftwm | grep -F "$@")" ]] && herbstclient add "$@"
  herbstclient use "$@"
}

s_closetag_herbstluftwm() {
  herbstclient use "$S_DEFAULT_TAG"
  herbstclient merge_tag "$S_SEL_TAG" "$S_DEFAULT_TAG"
}

s_focus_window_herbstluftwm() {
  xdotool windowactivate --sync "$@"
}

S_WM_SUPPORTS_LAYOUT_SAVING="1"

s_save_layout_herbstluftwm() {
  herbstclient dump
}

s_reload_layout_herbstluftwm() {
  herbstclient load "$(cat "$1")"
}

# vim: ft=sh ts=2 et sw=2:
