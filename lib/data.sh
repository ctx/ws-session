restored=res # name of current after restore

s_install_data() {
  mkdir -p $S_DATA_FOLDER
}

s_mv() {
  [[ -d "$1" ]] && mv "$1" "$2"
}

s_rotate_data() {
  local data_dir="$1"
  if [[ -n "$data_dir" ]] ; then
    [[ -d $S_DATA_FOLDER/$data_dir-$(($S_NUMBER_OF_BACKUPS)) ]] && \
      rm -rf "$S_DATA_FOLDER/$data_dir-$(($S_NUMBER_OF_BACKUPS))"
    for ((i=$((S_NUMBER_OF_BACKUPS-1)); i>=0; i--)) ; do
        s_mv "$S_DATA_FOLDER/$data_dir-$i" "$S_DATA_FOLDER/$data_dir-$(($i+1))"
    done
  fi
}

s_store_data() {
  local data_src="$1"
  local data_dir="$2"

  [[ -d $S_DATA_FOLDER/$data_dir-1 ]] && s_rotate_data "$data_dir"
  s_mv "$data_src" "$S_DATA_FOLDER/$data_dir-1"
}

s_restore_data() {
  local data_dir="$1"
  if [[ -d $S_DATA_FOLDER/$data_dir-2 ]] ; then
    [[ -d $S_DATA_FOLDER/$data_dir-$restored-1 ]] && s_rotate_data "$data_dir-$restored"
    s_mv "$S_DATA_FOLDER/$data_dir-1" "$S_DATA_FOLDER/$data_dir-$restored-1"
    for  ((i=2; i<=$(($S_NUMBER_OF_BACKUPS)); i++)) ; do
      s_mv "$S_DATA_FOLDER/$data_dir-$i" "$S_DATA_FOLDER/$data_dir-$(($i-1))"
    done
  fi
}

s_restore_selected_data(){
  local data_restore="$1"
  local data_dir="$2"
  if [[ -n "$data_restore" && -d $S_DATA_FOLDER/$data_restore ]] ; then
    s_mv "$S_DATA_FOLDER/$data_restore" "$S_DATA_FOLDER/tmp"
    s_rotate_data "$data_dir"
    s_mv "$S_DATA_FOLDER/tmp" "$S_DATA_FOLDER/$data_dir-1"
  fi
}

s_delete_all_backups() {
  local data_dir="$1"
  if [[ -d $S_DATA_FOLDER/$data_dir-1 ]] ; then
    s_mv "$S_DATA_FOLDER/$data_dir-1" "$S_DATA_FOLDER/tmp"
    find "$S_DATA_FOLDER" -type d -name "$data_dir-*" -exec rm -rf "{}" \; 2>/dev/null
    s_mv "$S_DATA_FOLDER/tmp" "$S_DATA_FOLDER/$data_dir-1"
  fi
}

s_list_sessions() {
  find $S_DATA_FOLDER -maxdepth 1 -type d -exec basename {} \; \
    | sed 's/-[0-9]$//' \
    | uniq
}

# vim: ft=sh ts=2 et sw=2:
