s_source wm/is-wm-running.sh

if [[ -z $WM ]] ; then
  [[ -d $S_CONFIG_FOLDER ]] && s_wms="$(find $S_CONFIG_FOLDER/wm/ -type f)"
  [[ -d $S_ROOT_FOLDER ]] && s_wms="$s_wms $(find $S_ROOT_FOLDER/wm/ -type f)"
  s_wms=$(echo "$s_wms" | sort -u | grep -v running.sh)
  for f in $s_wms ; do
    s_wm=$(basename -s .sh $f)
    if [[ $(s_running_wm_$s_wm) ]] ; then
      WM="$s_wm"
      break
    fi
  done
fi

if [[ -n $WM ]] ; then
  s_source wm/${WM}.sh

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
    s_list_app_seltag_$WM "$S_SEL_TAG"
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

  S_SEL_TAG="$(s_seltag)"
fi

# vim: ft=sh ts=2 et sw=2:
