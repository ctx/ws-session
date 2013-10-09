# open a vim session
# arg1: session file (the file/the folder)
s_vim_open_session() {
  local session="$1"
  find $session/vim -type f -exec bash -cxv "$S_TERM -name vim -e vim --servername $SELTAG- -S "{}"&" \; 
}

# close vim session
# arg1: temporary session dir
s_vim_close_session() {
  local tmp_dir="$1"
  vimservers=$(vim --serverlist | grep -i "^$SELTAG-")
  [[ $vimservers ]] && mkdir -p "$tmp_dir/vim"
  for vimserver in $vimservers ; do
    sessionfile="$tmp_dir/vim/$vimserver"
    vim --remote-send \
      '<Esc>:wa<CR>:mks '${sessionfile}'<CR>:qa<CR>' \
      --servername $vimserver
  done
}

s_vim_start() {
  $S_TERM -name vim -e vim -i $VIMINFO --servername "$SELTAG-" $@ &
}

# vim: ft=sh ts=2 et sw=2:

