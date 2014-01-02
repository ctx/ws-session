s_closesession() {
  if [[ -n $@ ]] ; then
    S_SEL_TAG="$@"
    s_new_tag "$@"
  fi
  session="$S_SEL_TAG"

  [[ $S_WM_SUPPORTS_LAYOUT_SAVING == 1 ]] && s_save_layout

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
      echo -e "$id\t$cwd\t$exe" >> "$S_TEMP_FOLDER/$S_SEL_TAG/autostart"
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

    while read -r l ; do
      id="$(echo "$l" | cut -f 1)"
      d="$(echo "$l" | cut -f 2)"
      cmd="$(echo "$l" | cut -f 3)"
      s_run_cmd_opensession "$id" "cd $d && $cmd"
    done < "$dir/autostart"
    unset l id d cmd

    for app in ${S_APPLICATIONS[@]} ; do
      eval s_${app}_open_session "$dir"
    done
    unset app


    if [[ -f $dir/${S_WM}.layout && $S_WM_SUPPORTS_LAYOUT_SAVING == "1" ]] ; then

      sleep $S_LOAD_LAYOUT_SLEEP

      s_restore_file ${S_WM}.layout
      while read -r id app ; do
        pid="$(xdotool getwindowpid $id)"
        if [[ -n ${pid_winid[$pid]} ]] ; then
          sed -i "s/${pid_winid[$pid]}/${id}/" "$tmp_dir/${S_WM}.layout"
          echo "replaced ${pid_winid[$pid]} with ${id}"
          [[ -f $S_TEMP_FOLDER/$name/command.tmp ]] && \
            sed -i "s/${pid_winid[$pid]}/${id}/" "$tmp_dir/command.tmp"
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

