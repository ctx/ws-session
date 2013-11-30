s_closesession() {
  if [[ -n $@ ]] ; then
    S_SEL_TAG="$@"
  fi
  session="$S_SEL_TAG"

  s_save_layout "$S_TEMP_FOLDER/$S_SEL_TAG"

  applications=$(s_list_app_seltag)
  for app in ${S_APPLICATIONS[@]} ; do
    winids="$(echo -e "$applications" | grep -i $app | cut -f1 -d" " | tr '\n' ' ')"
    s_${app}_close_session "$S_TEMP_FOLDER/$S_SEL_TAG" "$winids"
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
  local app=""
  local applications=""
  if [[ -z $name ]] ; then
    echo error no session name
    exit 1
  fi
  s_newtag "$name"
  S_SEL_TAG="$name"
  dir="$S_DATA_FOLDER/$name-1"
  tmp_dir="$S_TEMP_FOLDER/$name"

  mkdir -p "$tmp_dir"

  if [[ -d "$dir" ]] ; then

    for app in ${S_APPLICATIONS[@]} ; do
      eval s_${app}_open_session "$dir" "$tmp_dir"
    done

    s_restore_file autostart ${S_WM}.layout

    if [[ -f "$tmp_dir/autostart" ]] ; then
      while read -r app; do
        s_run_cmd "$app"
      done < "$tmp_dir/autostart"
    fi

    sleep 0.2

    while read -r app; do
      pid="$(xprop _NET_WM_PID -id ${app%% *}|sed 's/^.* = //')"
      [[ $pid ]] && sed -i "/${pid}/s/$/ ${app%% *}/" "$tmp_dir/pid-winid"
    done < <(s_list_app_seltag)

    while read -r line ; do
      local oldwinid=$(echo $line | cut -f2 -d" ")
      local newwinid=$(echo $line | cut -f3 -d" ")
      [[ $oldwinid && $newwinid ]] && sed -i "s/${oldwinid}/${newwinid}/" $tmp_dir/${S_WM}.layout
    done < "$tmp_dir/pid-winid"

    s_reload_layout "$tmp_dir"

  fi
}

s_restore_file() {
  for f in $@ ; do
    cp "$S_DATA_FOLDER/$S_SEL_TAG-1/$f" "$S_TEMP_FOLDER/$S_SEL_TAG/$f" 2>/dev/null
  done
}

# vim: ft=sh ts=2 et sw=2:

