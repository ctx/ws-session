ws-session
==========
----------

Session management for window managers with 'dynamic tags':
* Save the state of all windows of one tag and close them.
* Open a saved session on a new tag.
* ws-session is a small library of BASH functions and a wrapper around every
  used application to handle every special case seperately.

Other Session Management Solutions
----------------------------
* xsm and all other *-session programs eg xfce-session can only stop _all_ open
  windows.
* KDE has activites. They are working for KDE applications.
* dmtcp cannot save the state of X11 applications.
* Files can change during the 'sleep' of an application. If there is no builtin
  session support this may has to be addressed by the session manager.
* For many applications there is no point in saving the state.


Using ws-session
----------------
```bash
Usage:
  ws-session option [sessionname]
        You can only use one option at a time.
        Some options need a session name as argument.

Options:
  -a|all
        Close all sessions.
  -c|close
        Close active session.
  -h|help
        Print this help.
  -l|list
        List all saved sessions in '$S_DATA_FOLDER'.
  -m|menu
        Start a session from a menu.
        You have to set '$S_MENU' in the rc file.
  -o|open sessionname
        Start the session with name sessionname.
  -p|path:
        Prints the temporary path for dotfiles etc.
  -r|restore sessionname
        Restore a session to a previous state.
        You can do it up to '$S_NUMBER_OF_BACKUPS' times.
```

* Bind a key to 'ws-session menu' to create new workspaces.
* Bind a key to 'ws-session close' to close a workspace.

Dependencies
-----------
<dl>
<dt>Window Manager</dt>
<dd>One of: herbstluftwm, bspwm, i3, wmii</dd>
<dt>Applications</dt>
<dd>Some of: luakit, zathura, mupdf, urxvt, vim(gvim), dwb</dd>
<dt>Helpers</dt>
<dd>Probably most of: xprop, xdotool, bash, ls, and some others</dd>
<dd>i3: jshon<dd>
</dl>

Installation/Configuration
============

* Optain the source.

* Export S_LIB_FOLDER="/path/to/source" if you dont install to /usr/lib/ws-session.
  Replace the de/path/to/source if you didn't install.

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

You must not change the value of a global variable from the following section.
There are a few exeptions in some files in the lib/ folder.
You should access those from whithin all files in the other folders.

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
<dd>The file name of your shell history without the dot. To have a separate
shell history on every workspace the command ws-session -p can be used. Eg.
in your shellrc:
</dd>
<dd>Can be set in the rc file.</dd>
</dl>

Window Manager
--------------
* To use the tests (make test) you have to set the variable S_DEFAULT_TAG in
  the file ws-session.rc (in the git repo) to the tag you want to run the tests
  from.

* Copy lib/wm/is-wm-running.sh to your lib/wm folder and add a test for your wm.
  The function should echo the name of your wm if it's running and nothing else.

* Create a new file lib/wm/examplewm.sh with the functions:

```bash
# returns current tag
s_seltag_examplewm() {
}

# create a new tag with name "$@" and switch to it
s_newtag_examplewm() {
}

# switch to $S_DEFAULT_TAG and remove $S_SEL_TAG
s_closetag_examplewm() {
}

# list all open tags
s_list_open_tags_examplewm() [
}

# list winid and class of all open windows on $S_SEL_TAG
s_list_app_seltag_examplewm() {
}

# focus a window by its winid "$@"
s_focus_window_examplewm() {
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
# arg2: Temporary folder: this folder will be stored by s_exampleapp_close_session
s_exampleapp_open_session() {
}

# close exampleapp, save state to temporary folder
# arg1: Temporary folder: this folder will be stored in the end.
# arg2: winids of all exampleapps on current tag.
s_exampleapp_close_session() {
}

# start exampleapp in a way that close_session can close/save it
s_exampleapp_start() {
}
```

Sometimes one can ignore arg1 and/or arg2. Sometimes s_exampleapp_start is not
needed but exampleapp needs a setting in its config files, eg. urxvt.

TODO
====

* s_save_workspace_layout_$WM(), s_apply_workspace_layout_$WM()
* improve (english of) this README
* write a manual page
* bash completion for ws-session

