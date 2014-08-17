s_seltag_bspwm() {
  bspc query -D -d
}

s_list_app_seltag_bspwm() {
  bspc query -T -d "$S_SEL_TAG" \
    | awk 'NR<=1 {next} /0x/{print $3" "$2}' \
    | sort -u
}

s_list_open_tags_bspwm() {
  bspc query -D
}

s_newtag_bspwm() {
  if ! grep -q -F "$@" < <(bspc query -D) ; then 
    bspc monitor -a "$@"
  fi
  bspc desktop -f "$@"
}

s_closetag_bspwm() {
  bspc desktop -f "$S_DEFAULT_TAG"
  bspc monitor -r "$S_SEL_TAG"
}

s_focus_window_bspwm() {
  bspc window -f "$@"
}

S_WM_SUPPORTS_LAYOUT_SAVING="0"

s_save_layout_bspwm() {
  bspc query -T -d "$S_SEL_TAG"
}

s_reload_layout_bspwm() {
  nexttag="$(bspc query -D | grep "^$S_SEL_TAG$" -A1 | tail -1)"
  nexttag="${nexttag:- xxxxxxx}"
  oifs="$IFS"
  IFS=''
  hide=0
  bspc query -T | \
    while read -r l ; do
      if [[ "$l" =~ ^"  $S_SEL_TAG"  ]] ; then
        hide=1
        tail -n +2 "$1"
      elif [[ "$l" =~ ^"  $nexttag " ]] ; then
        hide=0
      fi
      [[ $hide == 0 ]] && echo "$l"
    done >> "${1}.tmp"
  bspc restore -T "${1}.tmp"
  rm -rf "${1}.tmp"
  IFS="$oifs"
  unset netxttag hide l oifs
}

# vim: ft=sh ts=2 et sw=2:
