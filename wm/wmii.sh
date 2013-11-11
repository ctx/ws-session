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
  wmiir cat /tag/sel/index | grep -v "^#" \
    | awk '{print $2" "$5}' | sed 's/:.*$//'
}

s_focus_window_wmii() {
  echo not yet
}

# vim: ft=sh ts=2 et sw=2:

