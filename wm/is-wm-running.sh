# Add your own to this list

s_running_wm_wmii() {
  if which wmiir > /dev/null 2>&1; then
    wmiir ls / 2> /dev/null
  fi
}

s_running_wm_i3() {
  if which i3-msg > /dev/null 2>&1; then
    i3-msg -t get_version 2> /dev/null
  fi
}

s_running_wm_default() {
  if which wmctrl > /dev/null 2>&1; then
    wmctrl -m | grep "$@"
  fi
}

s_running_wm_bspwm() {
  s_running_wm_default bspwm
}

s_running_wm_herbstluftwm() {
  s_running_wm_default herbstluftwm
}

s_running_wm_wingo() {
  s_running_wm_default Wingo
}

s_running_wm_llwm() {
  s_running_wm_default llwm
}

# vim: ft=sh ts=2 et sw=2:

