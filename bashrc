# .bashrc
# this file gets run in two cases:
# 1. non-login interactive shell
# 2. remote shell (over ssh or similar)

# #2 happens when you run "ssh user@host bash" explicitly.
# in this case, /etc/bash.bashrc has not been previous executed (unlike #1).
# however, we assume that #2 is a recovery mode, so we don't want to do much.
# (also, my google-fu didn't find a way to distinguish them)

# Only run for interactive shells
[[ $- != *i* ]] && return


# Global system definitions
[ -f /etc/bashrc ] && . /etc/bashrc

# Modules (interactive only)
[ -f ~/.modules ] && . ~/.modules

# Shared environment
. ~/.bash/env

# Interactive features (prompt, aliases, etc.)
. ~/.bash/interactive
