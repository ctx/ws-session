#!/bin/bash

s_seltag_llwm() {
  cdid="$(xprop -root _NET_CURRENT_DESKTOP|sed 's/.*= //')"
  dn=($(xprop -root _NET_DESKTOP_NAMES|sed 's/.*= //;s/,//g'))

  echo ${dn[$cdid]} | tr -d \"
}

s_list_app_seltag_llwm() {
  apps=($(xprop -root _LL_DESKTOP_WINIDS|sed 's/.*= //;s/,//g;s/\"//g'))
  for app in ${apps[@]} ; do
    echo -n "${app##*:} "
    xprop -id ${app##*:} WM_CLASS |sed 's/.*= \"//;s/\",.*$//'
  done
}

s_list_open_tags_llwm() {
  xprop -root _NET_DESKTOP_NAMES | sed 's/.*= //;s/,//g;s/\"//g'
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

# vim: ft=sh ts=2 et sw=2:
