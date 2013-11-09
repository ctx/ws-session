s_closesession() {
  if [[ $@ ]] ; then
    S_SEL_TAG="$@"
  fi
  session="$S_SEL_TAG"

  applications=$(s_list_app_seltag)
  for app in ${S_APPLICATIONS[@]} ; do
    winids="$(echo -e "$applications" | grep -i $app | cut -f1 -d" " | tr '\n' ' ')"
    s_${app}_close_session "$S_TEMP_FOLDER/$S_SEL_TAG" "$winids"
  done

  s_store_data $S_TEMP_FOLDER/$S_SEL_TAG $session

  while read -r app; do
    xdotool windowkill ${app%% *}
  done < <(echo "$applications")

  rm -rf "$S_TEMP_FOLDER/$S_SEL_TAG"

  s_closetag
}

s_opensession() {
  name="$@"
  if ! [[ $name ]] ; then
    echo error no session name
    exit 1
  fi
  s_newtag "$name"
  S_SEL_TAG=$name
  dir="$S_DATA_FOLDER/$name-1"
  tmp_dir="$S_TEMP_FOLDER/$name"
  if [[ -d "$dir" ]] ; then

    mkdir -p "$tmp_dir"

    for f in ${S_FILES_TO_COPY[@]} ; do
      [[ -f $dir/$f ]] && cp "$dir/$f" "$tmp_dir"
    done

    for app in ${S_APPLICATIONS[@]} ; do
      eval s_${app}_open_session "$dir" "$tmp_dir"
    done

    if [[ -f "$tmp_dir/autostart" ]] ; then
      bash $tmp_dir/autostart
    fi

  fi
}

s_run_cmd_opensession() {
  local cmd="$1"
  $cmd > /dev/null 2>&1 & disown
}

s_run_cmd() {
  local cmd="$1"
  $cmd > /dev/null 2>&1 & disown
}

# vim: ft=sh ts=2 et sw=2:

