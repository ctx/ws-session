s_closesession() {
  if [[ $@ ]] ; then
    session="$@"  
  else
    session="$SELTAG"
  fi

  applications=$(s_list_app_seltag)
  for app in ${APPLICATIONS[@]} ; do
    winids="$(echo -e "$applications" | grep -i $app | cut -f1 -d" " | tr '\n' ' ')"
    s_${app}_close_session "$S_TEMP_FOLDER/$SELTAG" "$winids"
  done

  s_store_data $S_TEMP_FOLDER/$SELTAG $session

  while read -r app; do
    xdotool windowkill ${app%% *}
  done < <(echo "$applications")

  rm -rf "$S_TEMP_FOLDER/$SELTAG"

  s_closetag
}

s_opensession() {
  name="$@"
  if ! [[ $name ]] ; then
    echo error no session name
    exit 1
  fi
  s_newtag "$name"
  SELTAG=$name
  dir="$S_DATA_FOLDER/$name-1"
  tmp_dir="$S_TEMP_FOLDER/$name"
  mkdir -p "$tmp_dir"
  if [[ -d "$dir" ]] ; then
    for f in ${FILESTOCOPY[@]} ; do
      [[ -f $dir/$f ]] && cp "$dir/$f" "$tmp_dir"
    done
    if [[ -f "$dir/autostart" ]] ; then
      bash $dir/autostart &
    else
      for app in ${APPLICATIONS[@]} ; do
        eval s_${app}_open_session "$dir" "$tmp_dir"
      done
    fi
  fi
}

# vim: ft=sh ts=2 et sw=2:

