ws-session
==========
----------

Session management for window managers with 'dynamic tags':
* Save the state of all windows of one tag and close them.
* Open a saved session on a new tag.


Session Management Solutions
----------------------------
* xsm and all other *-session programs eg xfce-session can only stop _all_ open windows.
* KDE has activites; working for KDE programs
* dmtcp cannot save the full state of X11 apps.
* Files can change during the 'sleep' of an app. If there is no builtin session support this has to be addressed in the session manager. 

* ws-session is a small library of BASH functions and a wrapper around every used app to handle every special case seperately.

* systemd user units could be interesting. Such a unit has to save and reload the state of an app.

Installation
============
make install
Adjust session.rc copy to $HOME/.session.rc or $XDG_CONFIG_HOME/ws-session/session.rc

Extending ws-session
===================

Global variable:
```bash
$SELTAG
```

To use the tests (make test) you have to set the variable DEFAULT_TAG in the file session.rc to the tag you want to run the tests from.

window manager support
----------------------
Create a new file lib/wm/examplewm.sh with the functions:

```bash
# returns current tag
s_seltag_examplewm() {
}

# creates new tag with name "$@" and switch to it
s_newtag_examplewm() {
}

# switch to $DEFAULT_TAG and removes $SELTAG
s_closetag_examplewm() {
}

# list winid and class of all open windows on $SELTAG
s_list_app_seltag_examplewm() {
}

# needed if xdotool windowactivate --sync "$@" fails
s_focus_window_examplewm() {
}
```

and run make test until the wm related tests dont throw wrong output (and no tag with name tagname exists afterwards).

application support
-------------------
Searching for tests.
Create a new file lib/wm/exampleapp.sh with the functions:

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

Sometimes one can ignore arg1/arg2. Sometimes s_exampleapp_start is not needed but exampleapp needs a setting in its config files.
There is no s_urxvt_start, but the history file of the shell gets set by  $(selecthistfile).


TODO
====

* Implement make install
* improve (english of) this README

