s_source wm/is-wm-running.sh

s_stop_if_no_wm() {
  if [[ -n $S_WM ]] ; then
    echo ERROR: no supported wm is running. stopping
    exit 1
  fi
}

if [[ -z $S_WM ]] ; then
  [[ -d $S_CONFIG_FOLDER ]] && s_wms="$(find $S_CONFIG_FOLDER/wm/ -type f 2>/dev/null)"
  [[ -d $S_ROOT_FOLDER ]] && s_wms="$s_wms $(find $S_ROOT_FOLDER/wm/ -type f 2>/dev/null)"
  s_wms=$(echo "$s_wms" | sort -u | grep -v running.sh)
  for f in $s_wms ; do
    s_wm=$(basename -s .sh $f)
    if [[ $(s_running_wm_$s_wm) ]] ; then
      S_WM="$s_wm"
      break
    fi
  done
else
  for f in $S_WM ; do
    if [[ "$(s_running_wm_$f)" ]] ; then
      s_wm="$f"
      break
    fi
  done
  if [[ "$s_wm" ]] ; then
    S_WM="$s_wm"
  else
    echo ERROR: you set \$S_WM to $S_WM and you dont run (one of) this wm
    unset S_WM
  fi
fi

unset s_wm s_wms

if [[ -n $S_WM ]] ; then
  s_source wm/${S_WM}.sh

  s_seltag() {
    s_seltag_$S_WM
  }

  s_newtag() {
    [[ $@ ]] && s_newtag_$S_WM "$@"
  }

  s_list_open_tags() {
    s_list_open_tags_$S_WM
  }

  s_closetag() {
    s_closetag_$S_WM
  }

  s_list_app_seltag() {
    s_list_app_seltag_$S_WM "$S_SEL_TAG"
  }

  s_focus_window() {
    s_focus_window_$S_WM "$@"
  }

  S_SEL_TAG="$(s_seltag)"
fi

# vim: ft=sh ts=2 et sw=2:
