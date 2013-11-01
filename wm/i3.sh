# didn't get that json or jshon thing
s_seltag_i3() {
  i3-msg -t get_workspaces \
    | jshon \
    | grep -B1 "visible\": true" \
    | head -1 \
    | sed 's/  \"name\": \"\(.*\)\",/\1/'
}

s_newtag_i3() {
  i3-msg workspace "$@" 2>&1 >/dev/null
}

s_closetag_i3() {
  i3-msg workspace "$S_DEFAULT_TAG" 2>&1 >/dev/null
}
  
s_list_app_seltag_i3() {
  winids="$(i3-msg -t get_tree \
    | jshon -e nodes -a -e nodes \
    | grep -e window -e name \
    | grep -v window_rect \
    | tr -d "\n" \
    | sed 's/,    \"/,\n\"/g' \
    | grep -A1 "\"name\": \"$(s_seltag_i3)\"" \
    | sed 's/\"window\"/\n/g;s/\"//g;s/\"name\"//g;s/: //g' \
    | tail -n+4 \
    | cut -d, -f1 \
    | grep -v null \
    | tr "\n" " ")"
  for id in $winids ; do
    winidhex="0x$(echo "ibase=10;obase=16;$id"|bc)"
    echo -n "$winidhex"
    xprop -id "$winidhex" \
      | grep WM_CLASS \
      | cut -d= -f2 \
      | cut -d, -f 1 \
      | sed 's/\"//g'
  done
}

# vim: ft=sh ts=2 et sw=2:

