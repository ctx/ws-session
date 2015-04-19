s_list_winids_app_seltag () {
  s_list_app_seltag \
    | awk -v IGNORECASE=1 -v ap="$app" -v ORS=" " \
      'match ($0,ap) {print $1}'
}

s_restore_file() {
  local f
  for f in $@ ; do
    cp "$S_DATA_FOLDER/$S_SEL_TAG-1/$f" "$S_TEMP_FOLDER/$S_SEL_TAG/$f" 2>/dev/null
  done
}

s_reg_winid() {
  local ppid=$(ps --ppid $1 -o pid=)
  [[ -z $ppid ]] && ppid=$1
  pid_winid[$ppid]="$2"
}

s_closesession() {
  if [[ -n $@ ]] ; then
    S_SEL_TAG="$@"
    s_newtag "$@"
  fi
  local session="$S_SEL_TAG"
  local tmp_dir="$S_TEMP_FOLDER/$S_SEL_TAG"

  [[ $S_WM_SUPPORTS_LAYOUT_SAVING == 1 ]] && s_save_layout

  for app in ${S_APPLICATIONS[@]} ; do
    winids="$(s_list_winids_app_seltag)"
    if [[ -n $winids ]] ; then
      s_${app}_close_session "$winids"
    fi
  done
  unset app winids

  echo -n > "$tmp_dir/autostart"
  ignore=( ${S_BLACKLIST[@]} ${S_APPLICATIONS[@]} )
  s_list_app_seltag | while read -r id app ; do
    if ! [[ "${ignore[@]}" =~ " $app " \
         || "${ignore[1]}" == "$app" \
         || "${ignore[${#ignore[@]}]}" == "$app" \
         ]] ; then 
      pid="$(xdotool getwindowpid $id)"
      cwd="$(readlink /proc/$pid/cwd)"
      exe="$(readlink /proc/$pid/exe)"
      echo -e "$id\t$cwd\t$exe" >> "$tmp_dir/autostart"
    fi
    xdotool windowkill $id
  done
  unset id pid app cwd exe ignore

  s_store_data "$tmp_dir" "$session"
  rm -rf "$tmp_dir"
  s_closetag
}

s_opensession() {
  local name="$@"
  if [[ -z $name ]] ; then
    s_fatal "No valid session name supplied" \
      "I need to know which session you want to open"
  fi
  local dir="$S_DATA_FOLDER/$name-1"
  local tmp_dir="$S_TEMP_FOLDER/$name"
  declare -a pid_winid

  s_newtag "$name"
  S_SEL_TAG="$name"
  mkdir -p "$tmp_dir"

  if [[ -d "$dir" ]] ; then

    for file in ${S_LN_FILES[@]} ; do
      ln -sf "$file" "$tmp_dir"
    done
    unset file

    pushd . > /dev/null
    while FS="\t" read -r winid d cmd ; do
      cd "$d"
      $cmd & >/dev/null 2>&1
      pid="$!"
      s_reg_winid $pid $winid
    done < "$dir/autostart"
    popd > /dev/null
    unset winid d cmd pid

    for app in ${S_APPLICATIONS[@]} ; do
      s_${app}_open_session "$dir"
    done
    unset app

    if [[ $S_WM_SUPPORTS_LAYOUT_SAVING == "1" && -f $dir/${S_WM}.layout ]] ; then

      sleep $S_LOAD_LAYOUT_SLEEP

      s_restore_file ${S_WM}.layout
      s_list_app_seltag | while read -r id app ; do
        pid="$(xdotool getwindowpid $id)"
        if [[ -n ${pid_winid[$pid]} ]] ; then
          sed -i "s/${pid_winid[$pid]}/${id}/" "$tmp_dir/${S_WM}.layout"
          [[ -f $tmp_dir/command.tmp ]] && \
            sed -i "s/${pid_winid[$pid]}/${id}/" "$tmp_dir/command.tmp"
        else
          s_error "Cannot find old winid: $pid $id $app" 
        fi
      done
      unset id app pid
      s_reload_layout
    fi

  fi
  unset pid_winid
}

# vim: ft=sh ts=2 et sw=2:

