# $OpenBSD: dot.profile,v 1.4 2005/02/16 06:56:57 matthieu Exp $
#
# sh/ksh initialization


xbacklight -set 20
. $HOME/.kshrc
PATH=$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games:.
ENV=$HOME/.kshrc
EDITOR=$(which vi)
export PATH HOME TERM ENV EDITOR
