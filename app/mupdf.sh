s_mupdf_hack() {
  local file="$(readlink -f "$@")"
  echo "$file" >> "$tmp_dir/mupdf-tmp"
  /usr/bin/mupdf "$@"
  sed -i "\|${file}|d" "$tmp_dir/mupdf-tmp"
}

# open mupdf from data folder, lockfiles and state should be stored in the temporary folder.
# arg1: Data folder: where the last session was stored.
# arg2: Temporary folder: this folder will be stored by s_mupdf_close_session
s_mupdf_open_session() {
  while read -r file ; do
    s_mupdf_hack ${file} &
  done < <(grep -v "^$" "$1/mupdf")
}

# close mupdf, save state to temporary folder
# arg1: Temporary folder: this folder will be stored in the end.
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
  if [[ $@ ]] ; then
    s_mupdf_hack $@
  else
    /usr/bin/mupdf
  fi
}
# vim: ft=sh ts=2 et sw=2:
