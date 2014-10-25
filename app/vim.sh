# Start a vim server for every started vim.

s_vim_open_session() {
  local folder="$1/vim"
  if  [[ -d "$folder" ]] ;then
    s_restore_file viminfo vimwinids
    local viminfo="$tmp_dir/viminfo"
    local vimwinids="$tmp_dir/vimwinids"
    find "$folder" -type f | while read -r f ; do
      id=$(awk "/$(basename "${f}")/{print \$1}" "$vimwinids")
      if [[ -n $id ]] ; then
        $S_TERM -name vim -e \
          /usr/bin/vim -i "$viminfo" --servername "$S_SEL_TAG-" -S "$f" \
          & > /dev/null 2>&1
        s_reg_winid $! $id
      fi
    done
    unset id f
  fi
}

s_vim_close_session() {
  local vimservers=$(/usr/bin/vim --serverlist | grep -i -e "^$S_SEL_TAG-")
  local winids="$1"
  local vimwinids="$tmp_dir/vimwinids"

  if [[ -n $winids ]] ; then
    echo -n "" > "$vimwinids"
    for id in $winids ; do
      echo -n "$id ">> "$vimwinids"
      xprop _NET_WM_NAME -id $id \
        | sed 's/^_NET_WM_NAME(UTF8_STRING) = \".* - //
               s/\"$//' >> "$vimwinids"
    done
    unset id

    mkdir -p "$tmp_dir/vim"
    for vimserver in $vimservers ; do
      sessionfile="$tmp_dir/vim/$vimserver"
      /usr/bin/vim --remote-send \
        '<Esc>:wa<CR>:mks! '${sessionfile}'<CR>:qa<CR>' \
        --servername $vimserver
    done
    unset vimserver sessionfile
  fi
}

s_vim_start() {
  local viminfo="$S_TEMP_FOLDER/$S_SEL_TAG/viminfo"
  if [[ -n $TERM ]] ; then
    winid=$(xprop -root _NET_ACTIVE_WINDOW |awk '{print $NF}')
    xprop -f WM_CLASS 8s -set WM_CLASS "vim" -id $winid
    /usr/bin/vim -i $viminfo --servername "$S_SEL_TAG-" "$@" 
    xprop -f WM_CLASS 8s -set WM_CLASS "$S_TERM" -id $winid
  else
    $S_TERM -name vim -e \
      /usr/bin/vim -i $viminfo --servername "$S_SEL_TAG-" "$@" \
      & > /dev/null 2>&1
  fi
  unset winid
}

# vim: ft=sh ts=2 et sw=2:

