#!/bin/bash

s_seltag_bspwm() {
  cdid="$(xprop -root _NET_CURRENT_DESKTOP|sed 's/.*= //')"
  dn=($(xprop -root _NET_DESKTOP_NAMES|sed 's/.*= //;s/,//g'))

  echo ${dn[$cdid]} | tr -d \"
}

s_list_app_seltag_bspwm() {
  bspc query -T -d "$SELTAG" \
    | grep "^ " | grep "0x" \
    | awk '{print $3" "$2}'
}

s_newtag_bspwm() {
  bspc monitor -a "$@"
  bspc desktop -f "$@"
}

s_closetag_bspwm() {
  bspc desktop -f "$DEFAULTTAG"
  bspc monitor -r "$SELTAG"
}

s_focus_window_bspwm() {
  bspc window -f "$@"
}

# vim: ft=sh ts=2 et sw=2:
