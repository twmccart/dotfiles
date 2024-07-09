#!/bin/sh

# /etc/X11/xinit/xinitrc
#
# global xinitrc file, used by all X sessions started by xinit (startx)

# invoke global X session script
setxkbmap -layout us,us -variant carpalx, -option grp:ctrls_toggle,shift:both_capslock_cancel,terminate:ctrl_alt_bksp
. /etc/X11/Xsession
