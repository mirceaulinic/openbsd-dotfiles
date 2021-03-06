#!/bin/ksh
#-*-Shell-script-*-

. /etc/ksh.kshrc

. ~/.ksh_paths

#grey="\033[01;30m"
#red="\033[01;31m"
#green="\033[01;32m"
#yellow="\033[01;33m"
#blue="\033[01;34m"
#magenta="\033[01;35m"
#cyan="\033[01;35m"
bold="\033[01;39m"
white="\033[0m"

#HISTFILE=~/.ksh_history
LC_CTYPE="en_US.UTF-8"
KEYID=0x1F81112D62A9ADCE
GPG_TTY=$(tty)
OS=$(uname)

unalias ls
alias ag='ag --nocolor'
alias build="dpb -c -h /home/buildie/hosts -P"
alias cabal='env TMPDIR=/usr/local/cabal/build/ cabal'
alias cdw='cd $(make show=WRKSRC)'
alias irc="export TERM=xterm; tmux at -t irc"
alias mkae='make'
alias mutt='stty discard undef; neomutt'
#alias pass="gopass"
alias spass="env PASSWORD_STORE_DIR=~/.secret-store pass"
alias pup='doas -n /usr/sbin/pkg_add -u'
alias rustc='rustc --color=never'
alias sbcl="rlwrap sbcl"
alias tmux="tmux -2"
#alias nord="dynamic_colors set nord"
#alias eink="dynamic_colors set eink"

#function eink {
#	dynamic_colors set eink
#	sed -i 's/^colorscheme.*/colorscheme eink/' \
#		~/.config/nvim/init.vim
#}
#
#function nord {
#	dynamic_colors set nord
#	sed -i 's/^colorscheme.*/colorscheme nord/' \
#		~/.config/nvim/init.vim
#}

if [ -e ~/.ksh_completions ]; then
    # shellcheck source=/home/qbit/.ksh_completions
    . ~/.ksh_completions
fi

if [ -e ~/.git-prompt ]; then
    # shellcheck source=/home/qbit/.git-prompt
   . ~/.git-prompt
   export GIT_PS1_SHOWDIRTYSTATE=true
   export GIT_PS1_SHOWUNTRACKEDFILES=true
   export GIT_PS1_SHOWCOLORHINTS=true
   export GIT_PS1_SHOWUPSTREAM="auto"
fi

LPREFIX=/usr/local

if [ "$OS" == "OpenBSD" ]; then
    if [ ! -f ~/.cvsrc ]; then
	export CVSROOT="anoncvs@anoncvs3.usa.openbsd.org:/cvs"
    fi
else
    LPREFIX=/usr
fi

DATADIR=/usr
export DATADIR

if [ -e ${LPREFIX}/bin/nvim ]; then
    alias vi="nvim"
fi

if [ -e ${LPREFIX}/bin/keychain ]; then
    ${LPREFIX}/bin/keychain --agents ssh,gpg -q
    keychain_conf="$HOME/.keychain/$(uname -n)-sh"

    [ -e "$keychain_conf" ]       && . $keychain_conf
    [ -e "${keychain_conf}-gpg" ] && . ${keychain_conf}-gpg
fi

function vdiff {
    cp -p "$1" "$1.orig"
    emacsclient -c "$1"
}

function pclean {
	find . -name \*.orig -exec rm {} \;
	find . -size 0 -exec rm {} \;
}

function git_branch_name {
    # __git_ps1 causes some slowness on large repos, don't run this there.
    for d in "${big_gits[@]}"; do
        if echo "${PWD}" | grep -q "${d}"; then
	    echo "[${bold}BIG${white}]"
            return
        fi
    done
    branch=$(__git_ps1 "%s")
    if [ "${branch}" != "" ]; then
	if [ "${branch}" = "(no branch)" ]; then
	    # probably have a tag
	    br_ch=$( perl -e 'binmode STDOUT, ":utf8"; print "\x{16D8}";' )
	    branch="$br_ch $( git describe --tags | head -n 1 )"
	fi
	echo "[${bold}${branch}${white}]"
    fi
}

function hg_q_name {
    if [ -d .hg ]; then
	if [ -f .hg/patches/status ]; then
	    branch=$(awk -F: '{print $NF}' .hg/patches/status)
	    if [ "${branch}" != "" ]; then
		echo "[${bold}${branch}${white}]"
	    fi
	fi
    fi
}

function ltodo {
    if [ -f .todo ]; then
	items=$(todo | wc -l | awk '{print $1}')
        if [ "${items}" != "0" ]; then
            printf "\n↪[${bold}TODO: %s%s]" "${items}" "${white}"
        fi
    fi
}

if [ -z "$DISPLAY" ]; then
	PS1='\u@\h($(battery -ln)%)[\[\e[01;$(($??31:39))m\]$?\[\e[0m]\]:\W\]$(git_branch_name)$(hg_q_name)$(ltodo)$ '
else
	PS1='\u@\h[\[\e[01;$(($??31:39))m\]$?\[\e[0m]\]:\W\]$(git_branch_name)$(hg_q_name)$(ltodo)$ '
fi

#dynamic_colors init

export PATH HOME TERM GOPATH GPG_TTY PS1 LC_CTYPE KEYID
