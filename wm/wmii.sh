s_seltag_wmii() {
  wmiir cat /tag/sel/ctl | sed '1q'
}

s_newtag_wmii() {
  wmiir xwrite /ctl view "$@"
}

s_list_open_tags_wmii() {
  wmiir ls /tag | sed ',/$,,'
}

s_closetag_wmii() {
  wmiir xwrite /ctl view "$S_DEFAULT_TAG"
}

s_list_app_seltag_wmii() {
  wmiir cat /tag/sel/index | awk '!/^#/{split($5,a,";"); print $2" "a[1]}'
}

s_focus_window_wmii() {
  xdotool windowactivate --sync "$@"
}

# vim: ft=sh ts=2 et sw=2:

