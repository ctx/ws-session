# open a vim session
# arg1: session file (the file/the folder)
s_vim_open_session() {
  local session="$1"
  find $session/vim -type f -exec bash -c "$S_TERM -name vim -e /usr/bin/vim --servername $SELTAG- -S "{}"&" disown \; 
}

# close vim session
# arg1: temporary session dir
s_vim_close_session() {
  local tmp_dir="$1"
  vimservers=$(vim --serverlist | grep -i "^$SELTAG-")
  [[ $vimservers ]] && mkdir -p "$tmp_dir/vim"
  for vimserver in $vimservers ; do
    sessionfile="$tmp_dir/vim/$vimserver"
    /usr/bin/vim --remote-send \
      '<Esc>:wa<CR>:mks '${sessionfile}'<CR>:qa<CR>' \
      --servername $vimserver
  done
}

s_vim_start() {
  VIMINFO="$S_TEMP_FOLDER/$SELTAG/viminfo"
  if [[ $TERM ]] ; then
    WINID=$(xprop -root _NET_ACTIVE_WINDOW |awk '{print $NF}')
    /usr/bin/vim -i $VIMINFO --servername "$SELTAG-" $@
  else
    $S_TERM -name vim -e /usr/bin/vim -i $VIMINFO --servername "$SELTAG-" $@ & disown
  fi
}

# vim: ft=sh ts=2 et sw=2:

