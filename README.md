ws-session
==========
start and stop workspaces/tags/desktops

About
----------
With ws-session you can have one session for every 'virtual desktop',
'workspace' or 'tag'.

You can start and stop sessions independent of each other.

You can configure what should be part of your sessions: browser history/tabs,
bash history, terminals with cwd, editors and open files, open pdfs, ncurses
applications and commands like mutt, htop, ssh (tmux attach) and everything
else you can think of and write a wrapper.

With herbstluftwm you can save and restore the layout of the workspace.

For seamless integration in you workflow you might want to:
* Bind a key to 'ws-session menu' to create new workspaces.
* Bind a key to 'ws-session close' to close a workspace.
* Run 'ws-session all' before you reboot/poweroff.

There is mostly no native support for such a thing:
* The wrappers in the bin folder make it possible to save the state of the
  applications.
* With the 'ws-cmd' wrapper you can start ncurses and other cli applications
  which should get restarted. No state is saved exept the cwd and cmdline.
* Applications which are not on the blacklist just get restarted. No state is
  saved exept the cwd and cmdline. 

Installation
----------
Get the code, export S_LIB_FOLDER=/path/to/code. Read, install and adjust
ws-session.rc.

https://github.com/ctx/ws-session/wiki/Installation-and-Configuration

Add a new application/window manager
----------
https://github.com/ctx/ws-session/wiki/Extend-ws-session

Author
----------
2013-2014 Ciril Troxler

Copying
----------
License GPLv3: http://gnu.org/licenses/gpl.html

