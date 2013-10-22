s_seltag_wmii() {
  wmiir cat /tag/sel/ctl | sed '1q'
}

s_newtag_wmii() {
  wmiir xwrite /ctl view "$@"
}

s_closetag_wmii() {
  wmiir xwrite /ctl view "$DEFAULT_TAG"
}

s_list_app_seltag_wmii() {
  wmiir cat /tag/sel/index | grep -v "^#" \
    | awk '{print $2" "$5}' | sed 's/:.*$//'
}

# vim: ft=sh ts=2 et sw=2:

