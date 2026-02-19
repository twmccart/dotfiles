# .bash_profile

# Load shared environment
. ~/.bash/env

# Login-specific setup
. ~/.bash/login

setxkbmap -layout us,us -variant carpalx, -option grp:ctrls_toggle,shift:both_capslock_cancel,terminate:ctrl_alt_bksp

# Load interactive config if this is interactive
[[ $- == *i* ]] && . ~/.bashrc
