# open a vim session
# arg1: session file (the file/the folder)
s_vim_open_session() {
  local session="$1"
  s_restore_file viminfo
  VIMINFO="$S_TEMP_FOLDER/$S_SEL_TAG/viminfo"
  find $session/vim -type f -exec bash -c "$S_TERM -name vim -e /usr/bin/vim -i $VIMINFO --servername $S_SEL_TAG- -S "{}"&" disown \; 
}

# close vim session
# arg1: temporary session dir
s_vim_close_session() {
  local tmp_dir="$1"
  vimservers=$(vim --serverlist | grep -i "^$S_SEL_TAG-")
  [[ $vimservers ]] && mkdir -p "$tmp_dir/vim"
  for vimserver in $vimservers ; do
    sessionfile="$tmp_dir/vim/$vimserver"
    /usr/bin/vim --remote-send \
      '<Esc>:wa<CR>:mks '${sessionfile}'<CR>:qa<CR>' \
      --servername $vimserver
  done
}

s_vim_start() {
  VIMINFO="$S_TEMP_FOLDER/$S_SEL_TAG/viminfo"
  if [[ $TERM ]] ; then
    WINID=$(xprop -root _NET_ACTIVE_WINDOW |awk '{print $NF}')
    xprop -f WM_CLASS 8s -set WM_CLASS "vim" -id $WINID
    /usr/bin/vim -i $VIMINFO --servername "$S_SEL_TAG-" $@
    xprop -f WM_CLASS 8s -set WM_CLASS "$S_TERM" -id $WINID
  else
    $S_TERM -name vim -e /usr/bin/vim -i $VIMINFO --servername "$S_SEL_TAG-" $@ & disown
  fi
}

# vim: ft=sh ts=2 et sw=2:
