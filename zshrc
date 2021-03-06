# stop messages
stty -ixon

# some zsh variables
ZDOTDIR=~/.zdotdir
HISTFILE=~/.zdotdir/.histfile
HISTSIZE=1000
SAVEHIST=1000
DART=$'\u25ba'
GITUSER=`git config user.name`

# modules
autoload -Uz colors && colors
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -Uz vcs_info
precmd () { vcs_info }

# options
setopt autocd extendedglob notify prompt_subst completealiases
unsetopt beep
bindkey -v

# autocomplete and command-not-found hook
zstyle :compinstall filename '~/.zshrc'
zstyle ':completion:*' menu select
[ -r /usr/share/doc/pkgfile/command-not-found.zsh ] && source /usr/share/doc/pkgfile/command-not-found.zsh

# add vcs information to prompt
function virtualenv_info(){
    venv=''
    [[ -n "$VIRTUAL_ENV" ]] && venv="${VIRTUAL_ENV##*/}"
    [[ -n "$venv" ]] && echo "$venv"
}
local VENV="$(virtualenv_info)";
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' formats "
%{$fg[red]%}$GITUSER%{$reset_color%}@%{$fg[cyan]%}%s:%{$fg[blue]%}%r/%b %m%u%c
"
# setup prompt
PROMPT="\$vcs_info_msg_0_%{$fg[red]%}%n%{$reset_color%}@%{$fg[cyan]%}%m:%{$fg[blue]%}%~
 %{$fg[blue]%}\$(virtualenv_info)%{$reset_color%} \$DART "
RPROMPT="[%{$fg[red]%}%?%{$reset_color%}]"

# setup keys
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key actions
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       history-beginning-search-backward
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     history-beginning-search-forward
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# zle only in application mode
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# general aliases
alias lsi='ls -ilah'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CFl'
alias sgrep='grep --color -n -r -s --exclude-dir=".git"'
alias sigrep='sgrep -i'
alias sgrepy='sgrep --include="*.py"'
alias sgrepj='sgrep --include="*.java"'
alias sigrepy='sigrep --include="*.py"'
alias findfile='find . -name '
alias rm='rm -i'
alias sdig='dig +noall +answer'
alias view='vim -R'
function md2man () { pandoc -s -f markdown -t man $1 | groff -T utf8 -man | less }
function pass_cmd () {
    sed -i -e "s/gtk-2/curses/g" ~/.gnupg/gpg-agent.conf
    echo RELOADAGENT | gpg-connect-agent
    /usr/bin/pass "$@"
    sed -i -e "s/curses/gtk-2/g" ~/.gnupg/gpg-agent.conf
    echo RELOADAGENT | gpg-connect-agent
}
alias pass='pass_cmd'
qrdecode() { zbarimg -S\*.disable -Sqrcode.enable "$1" -q | sed '1s/^[^:]\+://'; }

# general exported variables
export DISPLAY=:0
export EDITOR=vim
export JAVA_HOME=/usr/lib/jvm/default
export PATH=~/.cabal/bin:$PATH
export LESSHISTFILE=~/.config/less/lesshst
export XDG_CACHE_HOME=~/.cache
export PSQLRC=~/.config/psql/psqlrc

# virtualenv configuration
export VIRTUAL_ENV_DISABLE_PROMPT=1
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2.7
export WORKON_HOME=~/Envs
[ -r /usr/bin/virtualenvwrapper.sh ] && source /usr/bin/virtualenvwrapper.sh

[ -r $HOME/.zshrc.extra ] && source $HOME/.zshrc.extra
