#!/bin/bash

s_seltag_bspwm() {
  cdid="$(xprop -root _NET_CURRENT_DESKTOP|sed 's/.*= //')"
  difs="$IFS"
  IFS=,
  dn=( $(xprop -root _NET_DESKTOP_NAMES|sed 's/.*= //') )
  IFS="$difs"
  unset difs

  echo ${dn[$cdid]} | tr -d \"
}

s_list_app_seltag_bspwm() {
  bspc query -T -d "$S_SEL_TAG" \
    | grep "^ " | grep "0x" \
    | awk '{print $3" "$2}'
}

s_list_open_tags_bspwm() {
  bspc query -D
}

s_newtag_bspwm() {
  bspc monitor -a "$@"
  bspc desktop -f "$@"
}

s_closetag_bspwm() {
  bspc desktop -f "$S_DEFAULT_TAG"
  bspc monitor -r "$S_SEL_TAG"
}

s_focus_window_bspwm() {
  bspc window -f "$@"
}

# vim: ft=sh ts=2 et sw=2:
