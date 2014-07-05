ws-session
==========
A session manager for virtual desktops.

#### About

ws-session creates for every 'virtual desktop', 'workspace' or 'tag' one session.

You can start and stop sessions independent of each other.

You can configure what should be part of your sessions: browser history/tabs,
bash history, terminals with cwd, editors and open files, open pdfs, ncurses
applications like mutt, htop, ssh (tmux attach) and everything else you can
think of and write a wrapper.

With herbstluftwm you can save and restore the layout of the workspace.

The applications do not support this out of the box:
* The wrappers in the bin folder make it possible to save and restore the state
  of the applications.
* With the 'ws-cmd' wrapper you can start ncurses and other cli applications
  which should get restarted. No state is saved exept the cwd and cmdline.
* Applications which are not on the blacklist just get restarted. No state is
  saved exept the cwd and cmdline.

https://github.com/ctx/ws-session/wiki/What-should-work

#### Installation

* Get the code, export S_LIB_FOLDER=/path/to/code.
* Read, install and adjust ws-session.rc.
* For seamless integration in to your windowmanager, you can:
  * Bind a key to 'ws-session menu' to create new workspaces.
  * Bind a key to 'ws-session close' to close a workspace.
  * Configure reboot, poweroff, quit or other actions which you want to run 
    after closing all sessions (eg. ws-session all poweroff).

https://github.com/ctx/ws-session/wiki/Installation-and-Configuration

#### Add a new application/window manager
* Create new files in app/ or wm/
* test/debug them with the tests in test/

https://github.com/ctx/ws-session/wiki/Extend-ws-session

#### Copying
License GPLv3:<br />
http://gnu.org/licenses/gpl.html<br />
2013-2014 Ciril Troxler
