s_seltag_bspwm() {
  bspc query -D -d
}

s_list_app_seltag_bspwm() {
  bspc query -T -d "$S_SEL_TAG" | awk 'NR<=1 {next} /0x/{print $3" "$2}'
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

S_WM_SUPPORTS_LAYOUT_SAVING="1"

s_save_layout_bspwm() {
  bspc query -T -d
}

s_reload_layout_bspwm() {
  bspc restore -T "$1"
}

# vim: ft=sh ts=2 et sw=2:
