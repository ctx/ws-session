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

  applications=$(s_list_app_seltag)

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
  S_SEL_TAG="$name"
  dir="$S_DATA_FOLDER/$name-1"
  tmp_dir="$S_TEMP_FOLDER/$name"

  mkdir -p "$tmp_dir"

  if [[ -d "$dir" ]] ; then


    for app in ${S_APPLICATIONS[@]} ; do
      eval s_${app}_open_session "$dir" "$tmp_dir"
    done

    s_restore_file autostart

    if [[ -f "$tmp_dir/autostart" ]] ; then
      while read -r app; do
        s_run_cmd "$app"
      done < "$tmp_dir/autostart"
    fi

  fi
}

#s_run_cmd_opensession() {
#  local cmd="$1"
#  $cmd > /dev/null 2>&1 & disown
#}
#
#s_run_cmd() {
#  local cmd="$1"
#  $cmd > /dev/null 2>&1 & disown
#}

s_restore_file() {
  for f in $@ ; do
    cp "$S_DATA_FOLDER/$S_SEL_TAG-1/$f" "$S_TEMP_FOLDER/$S_SEL_TAG/$f" 2>/dev/null
  done
}

# vim: ft=sh ts=2 et sw=2:

