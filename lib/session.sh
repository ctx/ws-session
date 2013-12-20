s_closesession() {
  if [[ -n $@ ]] ; then
    S_SEL_TAG="$@"
    s_new_tag "$@"
  fi
  session="$S_SEL_TAG"

  s_save_layout

  for app in ${S_APPLICATIONS[@]} ; do
    winids="$(s_list_app_seltag | awk -v IGNORECASE=1 -v ap="$app" -v ORS=" " 'match ($0,ap) {print $1}')"
    if [[ -n $winids ]] ; then
      s_${app}_close_session "$winids"
    fi
  done
  unset app winids

  echo -n > "$S_TEMP_FOLDER/$S_SEL_TAG/autostart"
  while read -r id app ; do
    if ! [[ "${S_BLACKLIST[@]}" =~ "${app} " || "${S_BLACKLIST[${#S_BLACKLIST[@]}-1]}" == "${app}" ]] ; then 
      cwd="$(readlink /proc/$(xdotool getwindowpid $id)/cwd)"
      exe="$(readlink /proc/$(xdotool getwindowpid $id)/exe)"
      echo -e "$id cd $cwd;$exe" >> "$S_TEMP_FOLDER/$S_SEL_TAG/autostart"
    fi
    xdotool windowkill $id
  done < <(s_list_app_seltag)
  unset id app cwd exe

  s_store_data $S_TEMP_FOLDER/$S_SEL_TAG $session
  rm -rf "$S_TEMP_FOLDER/$S_SEL_TAG"
  s_closetag
}

s_opensession() {
  local name="$@"
  if [[ -z $name ]] ; then
    echo error no session name
    exit 1
  fi
  local dir="$S_DATA_FOLDER/$name-1"
  local tmp_dir="$S_TEMP_FOLDER/$name"
  declare -a pid_winid

  s_newtag "$name"
  S_SEL_TAG="$name"
  mkdir -p "$tmp_dir"

  if [[ -d "$dir" ]] ; then

    for app in ${S_APPLICATIONS[@]} ; do
      eval s_${app}_open_session "$dir"
    done
    unset app

    while read -r pid cmd ; do
      s_run_cmd_opensession "$pid" "$cmd"
    done < "$dir/autostart"
    unset pid cmd


    s_restore_file ${S_WM}.layout
    if [[ -f $tmp_dir/${S_WM}.layout ]] ; then
      sleep $S_LOAD_LAYOUT_SLEEP

      while read -r id app ; do
        pid="$(xdotool getwindowpid $id)"
        if [[ -n ${pid_winid[$pid]} ]] ; then
          sed -i "s/${pid_winid[$pid]}/${id}/" "$tmp_dir/${S_WM}.layout"
          sed -i "s/${pid_winid[$pid]}/${id}/" "$tmp_dir/command.tmp"
          echo "replaced ${pid_winid[$pid]} with ${id}"
        else
          echo Error: cannot find old winid: $pid $id $app
        fi
      done < <(s_list_app_seltag)
      unset id app pid
      s_reload_layout
    fi

  fi
  unset pid_winid
}

s_restore_file() {
  for f in $@ ; do
    cp "$S_DATA_FOLDER/$S_SEL_TAG-1/$f" "$S_TEMP_FOLDER/$S_SEL_TAG/$f" 2>/dev/null
  done
  unset f
}

# vim: ft=sh ts=2 et sw=2:

