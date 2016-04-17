s_help_vim() {
  echo 'About ws-session app files: zathura

Description:
    Start a vim server for every started vim.
    Use remote send to save vim sessions.

Usage:
    Use the ws-app wrapper to start vim.

Configuration:
    link ws-app to $PATH/vim eg:
    ln /usr/bin/ws-app $HOME/.config/ws-session/bin/vim

Dependencies:
    xprop
    vim with server features (on archlinux you need the gvim package)
  '
}

s_vim_open_session() {
  local directory="$1/vim"
  if  [[ -d "$directory" ]] ;then
    s_restore_file viminfo vimwinids
    local viminfo="$tmp_dir/viminfo"
    local vimwinids="$tmp_dir/vimwinids"
    find "$directory" -type f | while read -r f ; do
      id=$(awk "/$(basename "${f}")/{print \$1}" "$vimwinids")
      if [[ -n $id ]] ; then
        $S_TERM -name vim -e \
          /usr/bin/vim -i "$viminfo" --servername "$S_SEL_TAG-" -S "$f" \
          & >&3 2>&3
        s_reg_winid $! $id
      fi
    done
    unset id f
  fi
}

s_vim_close_session() {
  local vimservers=$(/usr/bin/vim --serverlist 2>&3 | grep -i -e "^$S_SEL_TAG-")
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
        --servername $vimserver \
        >&3 2>&3
    done
    unset vimserver sessionfile
  fi
}

s_vim_start() {
  local viminfo="$tmp_dir/viminfo"
  if [[ -n $TERM ]] ; then
    winid=$(xprop -root _NET_ACTIVE_WINDOW |awk '{print $NF}')
    xprop -f WM_CLASS 8s -set WM_CLASS "vim" -id $winid
    /usr/bin/vim -i $viminfo --servername "$S_SEL_TAG-" "$@" 
    xprop -f WM_CLASS 8s -set WM_CLASS "$S_TERM" -id $winid
  else
    $S_TERM -name vim -e \
      /usr/bin/vim -i $viminfo --servername "$S_SEL_TAG-" "$@" \
      & >&3 2>&3
  fi
  unset winid
}

# vim: ft=sh ts=2 et sw=2:

