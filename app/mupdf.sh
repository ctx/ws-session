# open mupdf from data folder, lockfiles and state should be stored in the temporary folder.
# arg1: Data folder: where the last session was stored.
# arg2: Temporary folder: this folder will be stored by s_mupdf_close_session
s_mupdf_open_session() {
  while read file ; do
    s_mupdf_start $file
  done < <(grep -v "^$" "$1/mupdf")
}

# close mupdf, save state to temporary folder
# arg1: Temporary folder: this folder will be stored in the end.
# arg2: winids of all mupdfs on current tag.
s_mupdf_close_session() {
  # save the tmp file because it will get empty bevore the data gets saved 
  local temp_dir="$1"
  cp "$temp_dir"/mupdf{-tmp,}
  rm "$temp_dir/mupdf-tmp"
}

# start exampleapp in a way that close_session can close/save it
s_mupdf_start() {
  if [[ $@ ]] ; then
    {
      local file="$(readlink -f "$@")"
      local temp_dir="$S_TEMP_FOLDER/$S_SEL_TAG"
      echo "$file" >> "$temp_dir/mupdf-tmp"
      /usr/bin/mupdf $@
      sed -i "\|${file}|d" $temp_dir/mupdf-tmp
    } & disown
  else
    /usr/bin/mupdf
  fi
}
# vim: ft=sh ts=2 et sw=2:
