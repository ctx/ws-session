ws-session
==========
A session manager for virtual desktops written in bash.

#### About

ws-session creates one session for every 'virtual desktop', 'workspace' or 'tag'.

You can start and stop sessions independent of each other.

You can configure what should be part of your sessions: browser history/tabs,
bash history, terminals with cwd, editors and open files, open pdfs, ncurses
applications like mutt, htop, ssh (tmux attach) and everything else you can
think of and write a wrapper.

Some window managers are able to save and restore the layout of the workspace.

The applications do not support this out of the box:
* The 'ws-app' wrapper in the bin folder makes it possible to save and restore
  the state of applications which have an 'app file' in the app folder.
* With the 'ws-cmd' wrapper you can start ncurses and other cli applications
  which will get restarted. No state is saved exept the cwd and cmdline.
* Other Applications which are not on the blacklist just get restarted. No state
  is saved exept the cwd and cmdline.

Further explanations can be found under the FILES section in the man page.

Look at the app and wm folders to see what is already supported or look here:
https://github.com/ctx/ws-session/wiki/What-should-work

Use man 7 ws-session to learn how to write new app or wm files or look here:
https://github.com/ctx/ws-session/wiki/Extend-ws-session


#### Dependencies
* xprop
* xdotool (for many apps)
* wmctrl (for most wms)
* jq (for i3)
* bash
* one of the supported window manager
* some of the supported applications

#### Installation

##### Archlinux
There is a package in the aur: ws-session-git
##### Other
* Get the code and use `export S_LIB_HOME=/path/to/code` in your
  xinitrc or autostart.

#### Configuration
* Create a folder for your saved sessions e.g. $HOME/.local/ws-session
* Read, install and adjust ws-session.rc.
* Create symliks for all the applications you want to use: Link ws-app to your
  $PATH e.g:
  `ln -s /usr/bin/ws-app $HOME/bin/vim`
* You can configure your shell to use dedicated histfiles.
* Create aliases for commands you want to be able to restore:
  `alias htop='ws-cmd htop'`
* For seamless integration with your windowmanager, you can:
  * Bind a key to 'ws-session menu' to create new workspaces.
  * Bind a key to 'ws-session close' to close a workspace.
  * Configure reboot, poweroff, quit or other actions which you want to run
    after closing all sessions (eg. `ws-session all poweroff`) and add them to
    your power menu.

https://github.com/ctx/ws-session/wiki/Installation-and-Configuration


#### Copying
License GPLv3:<br />
http://gnu.org/licenses/gpl.html<br />
2010-2015 Ciril Troxler
