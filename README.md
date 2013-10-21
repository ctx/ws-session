ws-session
==========
----------

Session management for window managers with 'dynamic tags':
* Save the state of all windows of one tag and close them.
* Open a saved session on a new tag.


Session Management
------------------
* xsm and all other *-session programs eg xfce-session can only stop _all_ open windows.
* KDE has activites; working for KDE programs; depends on the kdelibs.
* dmtcp cannot save the full state of X11 apps.
* Files can change during the 'sleep' of an app. If there is no builtin session support this has to be addressed in the session manager. 

* ws-session has a small library of BASH functions (persistence layer, support for window manager) and a wrapper around every used app to handle every special case seperately.

* systemd user units could be the way to go. Such a unit has to save and reload the state of an app. I never saw such an example.


Hacking ws-ssession
===================

window manager support
----------------------
Create a new file lib-wm-examplewm.sh with the functions:

```bash
s_seltag_examplewm() {
}

s_newtag_examplewm() {
}

s_closetag_examplewm() {
}

s_list_app_seltag_examplewm() {
}
```

and run make test until the wm related tests dont throw wrong output (and no tag with name tagname exists afterwards).

application support
-------------------
Searching for goot tests.

```bash
# open exampleapp from data folder, lockfiles and state should be stored in the temporary folder.
# arg1: Data folder: where the last session was stored.
# arg2: Temporary folder: this folder will be stored by s_exampleapp_close_session
s_exampleapp_open_session() {
}

# close exampleapp, save state to temporary folder
# arg1: Temporary folder: this folder will be stored in the end.
# arg2: winids of all $app on current tag.
s_exampleapp_close_session() {
}
```

