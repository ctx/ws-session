restored=res # name of current after restore

s_install_data() {
  mkdir -p $DATA_HOME
}

s_mv() {
  [[ -d "$1" ]] && mv "$1" "$2"
}

s_rotate_data() {
  local data_dir="$1"
  if [[ -n "$data_dir" ]] ; then
    [[ -d $DATA_HOME/$data_dir-$(($NUMBER_OF_BACKUPS)) ]] && \
      rm -rf "$DATA_HOME/$data_dir-$(($NUMBER_OF_BACKUPS))"
    for ((i=$((NUMBER_OF_BACKUPS-1)); i>=0; i--)) ; do
        s_mv "$DATA_HOME/$data_dir-$i" "$DATA_HOME/$data_dir-$(($i+1))"
    done
  fi
}

s_store_data() {
  local data_src="$1"
  local data_dir="$2"

  [[ -d $DATA_HOME/$data_dir-1 ]] && s_rotate_data "$data_dir"
  s_mv "$data_src" "$DATA_HOME/$data_dir-1"
}

s_restore_data() {
  local data_dir="$1"
  if [[ -d $DATA_HOME/$data_dir-2 ]] ; then
    [[ -d $DATA_HOME/$data_dir-$restored-1 ]] && s_rotate_data "$data_dir-$restored"
    s_mv "$DATA_HOME/$data_dir-1" "$DATA_HOME/$data_dir-$restored-1"
    for  ((i=2; i<=$(($NUMBER_OF_BACKUPS)); i++)) ; do
      s_mv "$DATA_HOME/$data_dir-$i" "$DATA_HOME/$data_dir-$(($i-1))"
    done
  fi
}

s_restore_selected_data(){
  local data_restore="$1"
  local data_dir="$2"
  if [[ -n "$data_restore" && -d $DATA_HOME/$data_restore ]] ; then
    s_mv "$DATA_HOME/$data_restore" "$DATA_HOME/tmp"
    s_rotate_data "$data_dir"
    s_mv "$DATA_HOME/tmp" "$DATA_HOME/$data_dir-1"
  fi
}

s_delete_all_backups() {
  local data_dir="$1"
  if [[ -d $DATA_HOME/$data_dir-1 ]] ; then
    s_mv "$DATA_HOME/$data_dir-1" "$DATA_HOME/tmp"
    find "$DATA_HOME" -type d -name "$data_dir-*" -exec rm -rf "{}" \; 2>/dev/null
    s_mv "$DATA_HOME/tmp" "$DATA_HOME/$data_dir-1"
  fi
}

# vim: ft=sh ts=2 et sw=2:
