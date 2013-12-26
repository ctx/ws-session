ws-session
==========
----------

This adds session management to window managers with support for adding and removing 'virtual desktops' aka 'workspaces'. This is nothing for people who use the functionality of tags like dwm propagates, because moving one application from one tag to another or having one application on more than one tag results in undefined/untested behaviour. But if you are a  traditional 'virtual desktop' or 'workspace' user ws-session makes it possible to do this two things:
* Save the state of all windows of one workspace and close them.
* Open a saved session on a new workspace.


Why not use one of the existing session managers:

* xsm and all other *-session programs eg xfce-session can only stop _all_ open
  windows at one time.
* KDE has activites. They are working for KDE applications.
* dmtcp cannot save the state of X11 applications.
* Files can change during the 'sleep' of an application. If there is no builtin
  session support this may has to be addressed by the session manager.
* For many applications there is no point in saving the state but it differs from user to user.

ws-session is a small library of BASH functions and a wrapper around every used
application to handle every special case seperately.
Or if an applicaion is not a special case, ws-session saves per default the cmd and cwd of all running applications. There is a blacklist to exclude some applications.


Using ws-session
----------------
The ws-session executable is the entry point for all session management:

* Bind a key to 'ws-session menu' to create new workspaces.
* Bind a key to 'ws-session close' to close a workspace.
* Run 'ws-session all' before you reboot/poweroff.

Only applications that are started through a wrapper in the bin folder can be saved.
With the 'ws-cmd' executable you can start ncurses applications.

Dependencies
------------
* Window Manager, one of:
  * herbstluftwm ++ supports saving and reloading the layout
  * bspwm
  * i3
  * wmii
  * or add support for your own: write wm/yourwm.sh

* Applications, some of:
  * luakit
  * dwb
  * zathura
  * (g)vim
  * urxvt
  * mupdf -- don't support layout saving

* Helpers, probably most of
  * xprop
  * xdotool
  * bash
  * ls
  * ...

Installation/Configuration
--------------

* Optain the source.

* Export S_LIB_FOLDER="/path/to/source" if you dont install to /usr/lib/ws-session.
  Replace the paths in this section with the /path/to/source if you didn't install.

* Copy the template /etc/xdb/ws-session/ws-session.rc to
  $HOME/.ws-session.rc. If you have set XDG_CONFIG_HOME as environment
  variable you can copy it to $XDG_CONFIG_HOME/ws-session.
  Adjust your ws-session.rc to your liking.

* Copy or link the executables you like from /etc/xdg/ws-session/bin/* to a folder in your $PATH.

* You can also copy some files from /usr/lib/ws-session/{app,wm} to
  $S_CONFIG_FOLDER/{app,wm} to change the default behavior or to test new ones.

* Configure your applications e.g. in your shellrc:
```bash
sessionpath="$(ws-session -p)"
[[ -z $sessionpath ]] && sessionpath="$HOME/."
export HISTFILE="${sessionpath}zsh_history"
export DIRSTACKFILE="${sessionpath}zdirs"
unset sessionpath
```

Extending ws-session
===================

You must not change the value of a global variable from the following section in any of the app, wm or bin files.
There are a few exeptions in some files in the lib/ folder.
You should access those from whithin all files/functions you want to write.

Global variables
----------------
<dl>
<dt>S_WM</dt>
<dd>This is a list of your preferred window manager(s). Can be one or more and
it get's truncated to the running wm.</dd>
<dd>Can be set in the rc file. But it gets set automatically otherwise.</dd>
<dt>S_APPLICATIONS</dt>
<dd>Array with the applications you want open and close with this script.<dd>
<dd>Must be set in the rc file.</dd>
<dt>S_LIB_FOLDER</dt>
<dd>Points to the folder with all the code in it. The executables in bin have
set it to /usr/lib/ws-session.</dd>
<dd>Set this like your other environement variables, if you dont want to use
the code in /usr/lib/ws-session. You can just export it for testing purposes.</dd>
<dt>S_CONFIG_FOLDER</dt>
<dd>Defaults to $XDG_CONFIG_HOME/ws-session, but if you name your rc file
$HOME/.ws-session.rc you can set this to wathever you like</dd>
<dd>Can be set in the rc file.</dd>
<dt>S_DATA_FOLDER</dt>
<dd>Per default points to $XDG_DATA_HOME/ws-session. Here are all the sessions saved.</dd>
<dd>Can be set in the rc file.</dd>
<dt>S_TEMP_FOLDER</dt>
<dd>Default: /tmp/ws-session.<dd> 
<dd>Can be set in the rc file.</dd>
<dt>S_NUMBER_OF_BACKUPS</dt>
<dd>How many backups of a session should get stored in S_DATA_FOLDER. Default 5.</dd>
<dd>Can be set in the rc file.</dd>
<dt>S_DEFAULT_TAG</dt>
<dd>If you close a session your window manager changes to this workspace.</dd>
<dd>Name it 1 or arch or whatever. There is no default.</dd>
<dt>S_SEL_TAG</dt>
<dd>Contains the active workspace.</dd>
<dd>Do not set this variable in the rc file, it gets set automatically.</dd>
<dt>S_MENU</dt>
<dd>Points to your favorite menu e.g. dmenu -nf #333 but can also be another
menu application.</dd>
<dd>Can be set in the rc file.</dd>
<dt>S_SHELL_HISTORY/S_SHELL_DIRS</dt>
<dd>The file name of your shell history/zdirs without the dot. To have a separate
shell history on every workspace the command ws-session -p can be used.
Those two variables are only used in the functions of app/urxvt.sh there might be a app/xterm.sh where those two variables could be used too.
</dd>
<dd>Can be set in the rc file.</dd>
</dl>

Window Manager
--------------
* To use the tests (make test) you have to set the variable S_DEFAULT_TAG in
  the file test/test-lib-wm.sh to the tag you want to run the tests
  from.

* Copy wm/is-wm-running.sh to your lib/wm folder and add a test for your wm.
  The function should echo something if it's running and nothing if not.

* Create a new file wm/examplewm.sh with the functions:

```bash
# returns current tag
s_seltag_examplewm() {
}

# create a new tag with name "$@" and switch to it
# dont create the tag if there is already one with that name
s_newtag_examplewm() {
}

# switch to $S_DEFAULT_TAG and remove $S_SEL_TAG
s_closetag_examplewm() {
}

# list all open tags
s_list_open_tags_examplewm() [
}

# list winid and class of all open windows on $S_SEL_TAG
# in the form of:
# 0x300000c3 urxvt
# 0x20000005 luakit
s_list_app_seltag_examplewm() {
}

# focus a window by its winid "$@"
s_focus_window_examplewm() {
}

# if the following variable is set to 1 ws-session tries to save
# and reload the layout.
S_WM_SUPPORTS_LAYOUT_SAVING="0"

# save the layout, the windowids will get replaced with the new
# ones when you start the session.
s_save_layout_examplewm() {
}

# reload the layout. The file in $1 contains the stored layout
# with the new windowids.
s_reload_layout_examplewm() {
}

```

* Run make test until the wm related tests dont throw wrong output (and no tag
  with name tagname exists afterwards).

Application
-----------
* Searching for tests.
* Create a new file lib/wm/exampleapp.sh with the functions:

```bash
# open exampleapp from data folder, lockfiles and state should be stored in the temporary folder.
# arg1: Data folder: where the last session was stored.
s_exampleapp_open_session() {
  # you have to start the application with the following command.
  # you want to load the old windowid to load the layout.
  s_run_cmd_opensession "$oldwinid" "command with -arguments"
}

# close exampleapp, save state to temporary folder
# arg1: winids of all exampleapps on current tag.
s_exampleapp_close_session() {
  # you want to save the actual windowid(s) to reload the layout.
  # In this example there is only one.
  echo $1 > "$S_TEMP_FOLDER/$S_SEL_TAG/exampleapp.winid"
}

# start exampleapp in a way that close_session can close/save it
s_exampleapp_start() {
  # to correctly disown your app you should use the following function
  s_run_cmd "command -arg" "argument with space.file"
}
```

Sometimes s_exampleapp_start is not needed but exampleapp needs a setting in its config files, eg. urxvt.

TODO
====

* improve (english of) this README
* write a manual page
* bash completion for ws-session/ws-cmd

