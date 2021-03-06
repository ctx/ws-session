s_help_mupdf(){
  echo 'About ws-session app files: mupdf

Description:
    This wrapper writes the file name to a file before mupdf
    gets started and removes the file name when mupdf gets closed.
    This method works when the names of open files is enough to
    restore a session.

Usage:
    Use the ws-app wrapper to start mupdf.

Configuration:
    link ws-app to $PATH/mupdf eg:
    ln /usr/bin/ws-app $HOME/.config/ws-session/bin/mupdf

Dependencies:
    xdotool
  '
}

s_mupdf_hack() {
  local file="$(readlink -f "$@")"
  echo "$file" >> "$tmp_dir/mupdf-tmp"
  /usr/bin/mupdf "$@"
  sed -i "\|${file}|d" "$tmp_dir/mupdf-tmp"
}

# open mupdf from data directory, lockfiles and state should be stored in the temporary directory.
# arg1: Data directory: where the last session was stored.
# arg2: Temporary directory: this directory will be stored by s_mupdf_close_session
s_mupdf_open_session() {
  local file
  grep -v "^$" "$1/mupdf" | while read -r file ; do
    s_mupdf_hack ${file} &
  done
}

# close mupdf, save state to temporary directory
# arg1: Temporary directory: this directory will be stored in the end.
# arg2: winids of all mupdfs on current tag.
s_mupdf_close_session() {
  # save the tmp file because it will get empty before the data gets saved
  local winids="$1"
  cp "$tmp_dir"/mupdf{-tmp,}

  for id in $winids ;  do
    xdotool windowkill $id
  done

  rm "$tmp_dir/mupdf-tmp"
}

# start exampleapp in a way that close_session can close/save it
s_mupdf_start() {
  if [[ "$@" ]] ; then
    s_mupdf_hack "$@"
  else
    /usr/bin/mupdf
  fi
}
# vim: ft=sh ts=2 et sw=2:
