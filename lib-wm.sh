if [[ $(wmiir ls / 2>/dev/null) ]] ; then
  WM=wmii
  source $SESSIONPATH/lib-wm-wmii.sh
elif [[ $(wmctrl -m | grep llwm) ]]; then
  WM=llwm
  source $SESSIONPATH/lib-wm-llwm.sh
elif [[ $(i3-msg -t get_version 2>/dev/null) ]]; then
  WM=i3
  source $SESSIONPATH/lib-wm-i3.sh
elif [[ $(wmctrl -m | grep bspwm) ]] ; then
  WM=bspwm
  source $SESSIONPATH/lib-wm-bspwm.sh
elif [[ $(wmctrl -m | grep Openbox) ]]; then
  WM=ob
  source $SESSIONPATH/lib-wm-ob.sh
else
  WM=NULL
fi

if [[ $WM != NULL ]] ; then
  s_seltag() {
    s_seltag_$WM
  }

  s_newtag() {
    [[ $@ ]] && s_newtag_$WM "$@"
  }

  s_closetag() {
    s_closetag_$WM
  }

  s_list_app_seltag() {
    s_list_app_seltag_$WM "$SELTAG"
  }

  if [[ $WM == bspwm ]] ; then
    s_focus_window() {
      s_focus_window_$WM "$@"
    }
  else
    s_focus_window() {
      xdotool windowactivate --sync "$@"
    }
  fi

  SELTAG="$(s_seltag)"
fi

# vim: ft=sh ts=2 et sw=2:
