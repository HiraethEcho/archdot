# tmux

## prefix

```
tmux show-options -g | grep prefix
```

```
tmux set -g prefix C-x tmux unbind C-b tmux bind C-x send-prefix
```

```
set -g prefix C-x unbind C-b bind C-x send-prefix
```

## session

```
tmux new -s $session_name

Ctrl+b :kill-session

tmux a -t $session_name

Ctrl+b :kill-server

session tmux kill-session -t $session_name

Ctrl+b $ // rename a session
```

## window

window in tmux is like tab in vim, and window can be moved into different sessions.

```
Ctrl+b +c       // creat a window
Ctrl+b &        // delete a window
Ctrl+b n        // next window
Ctrl+b p        // previous window
window Ctrl+b , // rename the window
Ctrl+b f        // search in windows
Ctrl+b l        // switch between windows
```

## pane

pane in tmux is like window in vim.

```
horizontal Ctrl+b ”               // vsplit pane
vertical Ctrl+b %                 // split pane
Ctrl+b o                          // move in panes
Ctrl+b :resize-pane -U
Ctrl+b :resize-pane -D
Ctrl+b :resize-pane -L
Ctrl+b :resize-pane -R
Ctrl+b :resize-pane -D 50         // resize pane
Ctrl+b {                          // movie pane to left
Ctrl+b }                          // movie pane to right
Ctrl+b x                          // delete pane
Ctrl+b <space>                    // change layout of panes
Ctrl+b !                          // move pane to a new window
Ctrl+b :join-pane -t $window_name // move pane into a window
Ctrl+b q                          // show pane index
```
