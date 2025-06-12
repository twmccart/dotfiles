# .bash_profile

# Ensure ~/.bash/env gets run first
. ~/.bash/env

# Prevent ~/.bash/env from being run later, since we need to use $BASH_ENV for non-login non-interactive shells.
# We don't export it, as we may have a non-login non-interactive shell as a child.
BASH_ENV=

# Run ~/.bash/login
. ~/.bash/login
setxkbmap -layout us,us -variant carpalx, -option grp:ctrls_toggle,shift:both_capslock_cancel,terminate:ctrl_alt_bksp

# Run ~/.bash/interactive if this is an interactive shell.
if [ "$PS1" ]; then
    . ~/.bash/interactive
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/ubuntu/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/ubuntu/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/ubuntu/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/ubuntu/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
