ws-session
==========
----------

Session management for window managers with 'dynamic tags':
* Save the state of all windows of one tag and close them.
* Open a saved session on a new tag.


Session Management Solutions
----------------------------
* xsm and all other *-session programs eg xfce-session can only stop _all_ open
  windows.
* KDE has activites. They are working for KDE applications.
* dmtcp cannot save the state of X11 applications.
* Files can change during the 'sleep' of an application. If there is no builtin
  session support this may has to be addressed by the session manager.

* ws-session is a small library of BASH functions and a wrapper around every
  used application to handle every special case seperately.
* For many applications there is no point in saving the state. You can put such
  applications in the autostart file.

Using ws-session
----------------
* In the shell
```bash
$ opensession sname     # open/create the session with name sname ;)
$ opensessionmenu       # open/create a session, show sessions if no menu is set
$ closesession sname    # close session
$ restoresession sname  # restore the second last state of a session.
$ editatuostart         # edit the autostart file of the active session
```

* From your window manager:

Bind a key to opensessionmenu to create new workspaces.
Bind a key to closesession to close a workspace.

Dependencies
-----------
<dl>
<dt>Window Manager</dt>
<dd>One of: bspwm, i3, wmii</dd>
<dt>Applications</dt>
<dd>Some of: luakit, mupdf, urxvt, vim</dd>
<dt>Helpers</dt>
<dd>Probably most of: xprop, xdotool, bash, ls, and some others</dd>
<dd>i3: jshon<dd>
</dl>

Installation/Configuration
============


* make install or git checkout

* Copy /etx/xdg/ws-session/ws-session.rc to
  $XDG_CONFIG_HOME/ws-session/ws-session.rc or $HOME/.ws-session.rc.

* Copy or link the executables you like from /etc/xdg/ws-session/bin/* to a folder in your $PATH.

* You can also copy some files from /usr/lib/ws-session/{app,wm} to
  $S_CONFIG_FOLDER/{app,wm} to change the default behavior or to test new ones.

* Global variables:
<dl>
<dt>S_WM</dt>
<dd>This is a list of your preferred window manager(s). Can be one or more and
it get's truncated to the running wm.</dd>
<dd>Can be set in the rc file. But it gets set automatically otherwise.</dd>
<dt>S_APPLICATIONS</dt>
<dd>Array with the applications you want open and close with this script.<dd>
<dd>Must be set in the rc file.</dd>
<dt>S_FILES_TO_COPY</dt>
<dd>Array with files which will be copied automatically for every session.</dd>
<dd>Must be set in the rc file.</dd>
<dt>S_ROOT_FOLDER</dt>
<dd>Points to the folder with all the code in it. If you install it, then this
is $PREFIX/lib/ws-session, but it can also point to a checkout of this
repo.</dd>
<dd>Must be set in every executable in bin/.</dd>
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
<dt>S_NUMBER_OF_BACKUPS<dt>
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
<dt>S_SHELL_HISTORY</dt>
<dd>The file name of your shell history without the dot. To have a separate
shell history on every workspace the script bin/selecthistfile can be used. Eg.
in your .zshrc: export HISTFILE="$(selecthistfile)". selecthisfile echos
$HOME/.$S_SHELL_HISTORY if no supported wm is running.</dd>
<dd>Can be set in the rc file.</dd>
</dl>


Extending ws-session
===================

You must not change the value of a global variable from the section above,
exept you are changing a file in lib/.
But you can access those from whithin all files in the other folders.

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

# list winid and class of all open windows on $S_SEL_TAG
s_list_app_seltag_examplewm() {
}

# needed if xdotool windowactivate --sync "$@" fails
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
needed but exampleapp needs a setting in its config files.  There is no
s_urxvt_start, but the history file of the shell gets set by
$(selecthistfile).


TODO
====

* s_save_workspace_layout_$WM(), s_apply_workspace_layout_$WM()
* improve (english of) this README
* write a manual page
* help output and bash completion for bin/{opensession,closesession,opensessionmenu,restoresession,editautostart}

