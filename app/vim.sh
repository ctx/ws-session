# Start a vim server for every started vim.

s_vim_open_session() {
  local folder="$1/vim"
  if  [[ -d "$folder" ]] ;then
    s_restore_file viminfo vimwinids
    local viminfo="$S_TEMP_FOLDER/$S_SEL_TAG/viminfo"
    while read -r f ; do
      id=$(grep -e "$(basename $f)" "$1/vimwinids" | cut -f1 -d" ")
      s_run_cmd_opensession $id "$S_TERM -name vim -e /usr/bin/vim -i $viminfo --servername $S_SEL_TAG- -S $f"
    done< <(find "$folder" -type f)
    unset id f
  fi
}

s_vim_close_session() {
  local tmp_vim_dir="$S_TEMP_FOLDER/$S_SEL_TAG/vim"
  local vimservers=$(vim --serverlist | grep -i "^$S_SEL_TAG-")
  local winids="$1"
  local idfile="$S_TEMP_FOLDER/$S_SEL_TAG/vimwinids"

  if [[ -n $winids ]] && mkdir -p "$tmp_vim_dir" ; then
    echo -n "" > "$idfile"
    for id in $winids ; do
      echo -n "$id ">> "$idfile"
      xprop _NET_WM_NAME -id $id \
        | sed 's/^_NET_WM_NAME(UTF8_STRING) = \".* - //
               s/\"$//' >> "$idfile"
    done
    unset id

    for vimserver in $vimservers ; do
      sessionfile="$tmp_vim_dir/$vimserver"
      /usr/bin/vim --remote-send \
        '<Esc>:wa<CR>:mks '${sessionfile}'<CR>:qa<CR>' \
        --servername $vimserver
    done
    unset vimserver sessionfile
  fi
}

s_vim_start() {
  local viminfo="$S_TEMP_FOLDER/$S_SEL_TAG/viminfo"
  mkdir -p "$S_TEMP_FOLDER/$S_SEL_TAG"
  if [[ -n $TERM ]] ; then
    winid=$(xprop -root _NET_ACTIVE_WINDOW |awk '{print $NF}')
    xprop -f WM_CLASS 8s -set WM_CLASS "vim" -id $winid
    /usr/bin/vim -i $viminfo --servername "$S_SEL_TAG-" "$@"
    xprop -f WM_CLASS 8s -set WM_CLASS "$S_TERM" -id $winid
  else
    s_run_cmd "$S_TERM" "-name vim -e /usr/bin/vim -i $viminfo --servername \"$S_SEL_TAG-\" $@"
  fi
  unset winid
}

# vim: ft=sh ts=2 et sw=2:

