s_closesession() {
  if [[ -n $@ ]] ; then
    S_SEL_TAG="$@"
  fi
  session="$S_SEL_TAG"

  s_save_layout "$S_TEMP_FOLDER/$S_SEL_TAG"

  applications=$(s_list_app_seltag)
  for app in ${S_APPLICATIONS[@]} ; do
    winids="$(echo -e "$applications" | grep -i $app | cut -f1 -d" " | tr '\n' ' ')"
    s_${app}_close_session "$winids"
  done

  s_store_data $S_TEMP_FOLDER/$S_SEL_TAG $session

  applications=$(s_list_app_seltag)

  while read -r app; do
    xdotool windowkill ${app%% *}
  done < <(echo "$applications")
  unset app

  rm -rf "$S_TEMP_FOLDER/$S_SEL_TAG"

  s_closetag
}

s_opensession() {
  local name="$@"
  if [[ -z $name ]] ; then
    echo error no session name
    exit 1
  fi
  local app=""
  local applications=""
  local dir="$S_DATA_FOLDER/$name-1"
  local tmp_dir="$S_TEMP_FOLDER/$name"
  local pid_winid=""

  s_newtag "$name"
  S_SEL_TAG="$name"

  mkdir -p "$tmp_dir"

  if [[ -d "$dir" ]] ; then

    for app in ${S_APPLICATIONS[@]} ; do
      eval s_${app}_open_session "$dir"
    done

    sleep 0.2

    s_restore_file ${S_WM}.layout
    if [[ -f $tmp_dir/${S_WM}.layout ]] ; then
      while read -r newwinid ; do
        pid="$(xprop _NET_WM_PID -id ${newwinid%% *}|sed 's/^.* = //')"
        if [[ -n ${pid_winid[$pid]} ]] ; then
          sed -i "s/${pid_winid[$pid]}/${newwinid%% *}/" "$tmp_dir/${S_WM}.layout"
        else
          echo Error: cannot find old winid: $pid $newwinid
        fi
      done < <(s_list_app_seltag)
    fi
    s_reload_layout "$tmp_dir"

  fi
}

s_restore_file() {
  for f in $@ ; do
    cp "$S_DATA_FOLDER/$S_SEL_TAG-1/$f" "$S_TEMP_FOLDER/$S_SEL_TAG/$f" 2>/dev/null
  done
}

# vim: ft=sh ts=2 et sw=2:

