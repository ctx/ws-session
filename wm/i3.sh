s_seltag_i3() {
  i3-msg -t get_workspaces \
    | jq -c '.[] | select(.focused) | .name' --raw-output
}

s_newtag_i3() {
  i3-msg workspace "$@" 2>&1 >/dev/null
}

s_list_open_tags_i3() {
  i3-msg -t get_workspaces \
    | jq -c '.[] | .name' --raw-output
}

s_closetag_i3() {
  i3-msg workspace "$S_DEFAULT_TAG" 2>&1 >/dev/null
}
  
s_list_app_seltag_i3() {
  local id
  i3-msg -t get_tree \
    | jq --raw-output \
      ".nodes[].nodes[].nodes[]|select(contains({name:\"$S_SEL_TAG\"})).nodes[].nodes[].window" \
    | while read -r id ; do
      s_print_id_class "0x$(printf '%0x\n' $id)"
    done
}

s_focus_window_i3() {
  local c="$@"
  local winiddec="$(printf "%u\n" $@)"
  i3-msg "[id=\"$winiddec\"] focus" > /dev/null
}

# vim: ft=sh ts=2 et sw=2:

