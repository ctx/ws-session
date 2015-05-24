restored=res # name of current after restore

if [[ ! -d "$S_DATA_HOME" ]] ; then
  s_fatal "Cannot find data directory: '$S_DATA_HOME'" \
    "Create a directory and set S_DATA_HOME in your rc file"
fi

s_mv() {
  [[ -d "$1" ]] && mv "$1" "$2"
}

s_rotate_data() {
  local data_dir="$1"
  if [[ -n "$data_dir" ]] ; then
    [[ -d $S_DATA_HOME/$data_dir-$(($S_NUMBER_OF_BACKUPS)) ]] && \
      rm -rf "$S_DATA_HOME/$data_dir-$(($S_NUMBER_OF_BACKUPS))"
    for ((i=$((S_NUMBER_OF_BACKUPS-1)); i>=0; i--)) ; do
        s_mv "$S_DATA_HOME/$data_dir-$i" "$S_DATA_HOME/$data_dir-$(($i+1))"
    done
  fi
}

s_store_data() {
  local data_src="$1"
  local data_dir="$2"

  [[ -d $S_DATA_HOME/$data_dir-1 ]] && s_rotate_data "$data_dir"
  s_mv "$data_src" "$S_DATA_HOME/$data_dir-1"
}

s_restore_data() {
  local data_dir="$1"
  if [[ -d $S_DATA_HOME/$data_dir-2 ]] ; then
    [[ -d $S_DATA_HOME/$data_dir-$restored-1 ]] && s_rotate_data "$data_dir-$restored"
    s_mv "$S_DATA_HOME/$data_dir-1" "$S_DATA_HOME/$data_dir-$restored-1"
    for  ((i=2; i<=$(($S_NUMBER_OF_BACKUPS)); i++)) ; do
      s_mv "$S_DATA_HOME/$data_dir-$i" "$S_DATA_HOME/$data_dir-$(($i-1))"
    done
  fi
}

s_restore_selected_data(){
  local data_restore="$1"
  local data_dir="$2"
  if [[ -n "$data_restore" && -d $S_DATA_HOME/$data_restore ]] ; then
    s_mv "$S_DATA_HOME/$data_restore" "$S_DATA_HOME/tmp"
    s_rotate_data "$data_dir"
    s_mv "$S_DATA_HOME/tmp" "$S_DATA_HOME/$data_dir-1"
  fi
}

s_delete_all_backups() {
  local data_dir="$1"
  if [[ -d $S_DATA_HOME/$data_dir-1 ]] ; then
    s_mv "$S_DATA_HOME/$data_dir-1" "$S_DATA_HOME/tmp"
    find "$S_DATA_HOME" -type d -name "$data_dir-*" -exec rm -rf "{}" \; 2>/dev/null
    s_mv "$S_DATA_HOME/tmp" "$S_DATA_HOME/$data_dir-1"
  fi
}

s_list_sessions() {
  find "$S_DATA_HOME" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; \
    | sed 's/-[0-9]$//' \
    | sort -u
}

# vim: ft=sh ts=2 et sw=2:
