s_source wm/is-wm-running.sh

s_stop_if_no_wm() {
  if [[ -z $S_WM ]] ; then
    s_fatal "No supported wm is running"
  fi
}

s_find_wm() {
  find "$1/wm" -type f \
               -not -name '.*' \
               -not -name 'is-wm-running.sh' \
               -exec basename -s .sh {} \+ \
               2>/dev/null
}

s_reg_winid() {
  local ppid=$(ps --ppid $1 -o pid=)
  [[ -z $ppid ]] && ppid=$1
  pid_winid[$ppid]="$2"
}

if [[ -z $DISPLAY ]] ; then 
  unset S_WM
elif [[ -z $S_WM ]] ; then
  if [[ -d $S_CONFIG_FOLDER ]] ; then
    s_wms="$(s_find_wm "$S_CONFIG_FOLDER")"
  fi
  if [[ -d $S_LIB_FOLDER ]] ; then
    s_wms="$s_wms
$(s_find_wm "$S_LIB_FOLDER")"
  fi
  s_wms="$(sort -u <<< "$s_wms")"
  for f in $s_wms ; do
    if [[ -n $(s_running_wm_$f 2>/dev/null) ]] ; then
      s_wm="$f"
      break
    fi
  done
  unset f
else
  for f in $S_WM ; do
    if [[ -n "$(s_running_wm_$f 2>/dev/null)" ]] ; then
      s_wm="$f"
      break
    fi
  done
  unset f
fi

if [[ -n "$s_wm" ]] ; then
  S_WM="$s_wm"

  s_source wm/${S_WM}.sh

  S_SEL_TAG="$(s_seltag_$S_WM)"

  s_seltag() {
    s_seltag_$S_WM
  }

  s_newtag() {
    [[ -n $@ ]] && s_newtag_$S_WM "$@"
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

  if [[ $S_WM_SUPPORTS_LAYOUT_SAVING == 1 ]] ; then
    s_save_layout() {
      s_save_layout_$S_WM  > "$S_TEMP_FOLDER/$S_SEL_TAG/$S_WM.layout"
    }

    s_reload_layout() {
      local file="$S_TEMP_FOLDER/$S_SEL_TAG/${S_WM}.layout"
      [[ -f $file ]] && s_reload_layout_$S_WM "$file"
    }
  else
    s_run_cmd_opensession() {
      shift
      s_run_cmd "$@"
    }
  fi

  s_print_id_class() {
    echo -n "$1 "
    xprop -id "$1" WM_CLASS \
      | sed 's/^.* = \"//;s/\", \".*$//;s/\"$//'
  }

else
  if [[ $DISPLAY ]] ; then
    s_error "You set \$S_WM to '$S_WM' and you dont run (one of) this wm" \
      "Change or unset S_WM in your rc file"
  else
    s_error "You dont run a wm and \$DISPLAY is empty" \
      "You cannot use ws-session on a tty"
  fi
  unset S_WM
fi

unset s_wm s_wms

# vim: ft=sh ts=2 et sw=2: