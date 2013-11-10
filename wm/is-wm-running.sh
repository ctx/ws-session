# Add your own to this list

s_running_wm_wmii() {
  wmiir ls / 2>/dev/null
}

s_running_wm_i3() {
  i3-msg -t get_version 2>/dev/null
}

s_running_wm_bspwm() {
  wmctrl -m | grep bspwm
}

s_running_wm_llwm() {
  wmctrl -m | grep llwm
}

# vim: ft=sh ts=2 et sw=2:

