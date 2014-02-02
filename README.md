ws-session
==========

With ws-session you can have seperate sessions for every 'virtual desktop', 'workspace' or 'tag'.

You can start and stop sessions independent of each other.

You can configure what should be part of your sessions: browser history/tabs, bash history, terminals with cwd, editors and open files, open pdfs, ncurses applications and commands like mutt, htop, ssh (tmux attach) and everything else you can think of and write a wrapper.

Usage
----------
This are some examples for some options. Run 'ws-session help' to find out all other options.
* Bind a key to 'ws-session menu' to create new workspaces.
* Bind a key to 'ws-session close' to close a workspace.
* Run 'ws-session all' before you reboot/poweroff.
* The state of an application can only be saved when it was started through a wrapper in the bin folder.
* With the 'ws-cmd' wrapper you can start ncurses applications and probably others.
* Applications which are not on the blacklist just get restarted. No state is saved exept the cwd and cmdline. 

Installation
----------
Get the code, export S_LIB_FOLDER=/path/to/code. Read, install and adjust ws-session.rc.

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

