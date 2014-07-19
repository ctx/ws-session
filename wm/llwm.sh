s_seltag_llwm() {
  cdid="$(xprop -root _NET_CURRENT_DESKTOP|sed 's/.*= //')"
  dn=( $(xprop -root _NET_DESKTOP_NAMES \
           | sed 's/^.*= //;
                  s/^\"//;
                  s/\"$//;
                  s/\", \"/\n/g') )

  echo ${dn[$cdid]} | sed 's/\\\"/\"/g'
}

s_list_app_seltag_llwm() {
  apps=($(xprop -root _LL_DESKTOP_WINIDS \
    | cut -f2 -d= \
    | tr -d '[",]' ))
  for app in ${apps[@]} ; do
    echo -n "${app##*:} "
    xprop -id ${app##*:} WM_CLASS \
      | cut -f2 -d'"'
  done
}

s_list_open_tags_llwm() {
  xprop -root _NET_DESKTOP_NAMES \
           | sed 's/^.*) = //;
                  s/^\"//;
                  s/"$//;
                  s/\", \"/\n/g;
                  s/\\\"/\"/g'
}

s_newtag_llwm() {
  xprop -root -f _LL_ACTIVE_DESKTOP 8s -set _LL_ACTIVE_DESKTOP "$@"
}

s_closetag_llwm() {
  s_newtag_llwm $S_DEFAULT_TAG
}

s_focus_window_llwm() {
  xdotool windowactivate --sync "$@"
}

s_save_layout_llwm() {
  xprop -root _LL_DESKTOP_WINIDS \
    | cut -f2 -d= \
    | tr -d '[",]'
}

s_reload_layout_llwm() {
  echo no can do
}

# vim: ft=sh ts=2 et sw=2:
