# manjaro i3 version

## i3
`$mod+0`:

```
# Set shut down, restart and locking features
bindsym $mod+0 mode "$mode_system"
set $mode_system (l)ock, (e)xit, switch_(u)ser, (s)uspend, (h)ibernate, (r)eboot, (Shift+s)hutdown
mode "$mode_system" {
    bindsym l exec --no-startup-id i3exit lock, mode "default"
    bindsym s exec --no-startup-id i3exit suspend, mode "default"
    bindsym u exec --no-startup-id i3exit switch_user, mode "default"
    bindsym e exec --no-startup-id i3exit logout, mode "default"
    bindsym h exec --no-startup-id i3exit hibernate, mode "default"
    bindsym r exec --no-startup-id i3exit reboot, mode "default"
    bindsym Shift+s exec --no-startup-id i3exit shutdown, mode "default"

    # exit system mode: "Enter" or "Escape"
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
```

Lock screen:
```
bindsym $mod+9 exec --no-startup-id blurlock
```

Autostart applications:
```
exec --no-startup-id nitrogen --restore; sleep 1; picom -b
exec --no-startup-id start_conky_live_maia
```
### i3-bar

```
Start i3bar to display a workspace bar (plus the system information i3status if available)
bar {
	i3bar_command i3bar
	status_command i3status
	position bottom

## please set your primary output first. Example: 'xrandr --output eDP1 --primary'
#	tray_output primary
#	tray_output eDP1

	bindsym button4 nop
	bindsym button5 nop
#   font xft:URWGothic-Book 11
	strip_workspace_numbers yes

    colors {
        background #222D31
        statusline #F9FAF9
        separator  #454947

#                      border  backgr. text
        focused_workspace  #F9FAF9 #16a085 #292F34
        active_workspace   #595B5B #353836 #FDF6E3
        inactive_workspace #595B5B #222D31 #EEE8D5
        binding_mode       #16a085 #2C2C2C #F9FAF9
        urgent_workspace   #16a085 #FDF6E3 #E5201D
    }
}

# hide/unhide i3status bar
bindsym $mod+m bar mode toggle
```
## morc_menu


## conkey

## dmenu

## bmenu

## polybar
