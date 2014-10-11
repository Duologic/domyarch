# stop messages
stty -ixon

# some zsh variables
HISTFILE=~/.histfile
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
alias ls='ls --color'
alias lsi='ls -ilah'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias sgrep='grep --color -n -r -s --exclude-dir=".git"'
alias sigrep='sgrep -i'
alias sgrepy='sgrep --include="*.py"'
alias sigrepy='sigrep --include="*.py"'
alias rm='rm -i'
alias view='vim -R'
function pass_cmd () {
    sed -i -e "s/gtk-2/curses/g" ~/.gnupg/gpg-agent.conf
    echo RELOADAGENT | gpg-connect-agent
    /usr/bin/pass "$@"
    sed -i -e "s/curses/gtk-2/g" ~/.gnupg/gpg-agent.conf
    echo RELOADAGENT | gpg-connect-agent
}
alias pass='pass_cmd'

# local aliases
alias time='/usr/bin/time -f "\nTime: %E | CPU: %P | MEM: %M KiB"'
alias xlock='xscreensaver-command -lock'

# general exported variables
export DISPLAY=:0
export EDITOR=vim
export JAVA_HOME=/usr/lib/jvm/default
export PATH=~/.gem/ruby/2.1.0/bin:$PATH

# virtualenv configuration
export VIRTUAL_ENV_DISABLE_PROMPT=1
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2.7
export WORKON_HOME=~/Envs
[ -r /usr/bin/virtualenvwrapper.sh ] && source /usr/bin/virtualenvwrapper.sh

# tmux config
[ -n "$TMUX" ] && export TERM=screen-256color
if which tmux 2>&1 >/dev/null; then
    test -z "$TMUX" && (tmux attach || tmux new-session)
fi

# ssh and gpg agent config
eval $(keychain --eval --agents ssh -Q --quiet --ignore-missing id_ecdsa id_rsa)
if [ $EUID -ne 0 ] ; then
    envfile="$HOME/.gnupg/gpg-agent.env"
    if [[ -e "$envfile" ]] && kill -0 $(grep GPG_AGENT_INFO "$envfile" | cut -d: -f 2) 2>/dev/null; then
        eval "$(cat "$envfile")"
    else
        eval "$(gpg-agent --daemon --write-env-file "$envfile")"
    fi
    export GPG_AGENT_INFO  # the env file does not contain the export statement
#    export SSH_AUTH_SOCK   # enable gpg-agent for ssh
fi