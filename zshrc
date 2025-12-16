
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# History
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS \
       HIST_IGNORE_ALL_DUPS \
       HIST_FIND_NO_DUPS \
       HIST_REDUCE_BLANKS \
       HIST_VERIFY \
       SHARE_HISTORY

# Usability
setopt autocd                 # cd by typing dir name
setopt correct                # spelling correction
setopt extendedglob           # advanced globbing
setopt interactivecomments    # comments in interactive shell
setopt nocaseglob             # case-insensitive path matching

# Keybindings
bindkey -e                    # emacs mode

# ------------------------------------------------------------
# COMPLETION (fancy, colored, smart)
# ------------------------------------------------------------
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
compinit

# ------------------------------------------------------------
# PROMPT / POWERLEVEL10K
# ------------------------------------------------------------
if [[ -r /home/ravi/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme ]]; then
    source /home/ravi/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
else
    # Fallback minimal prompt
    PROMPT='%F{cyan}%n%f at %F{magenta}%m%f %F{yellow}%1~%f %# '
fi

# Optional: P10k config file (after first configuration)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ------------------------------------------------------------
# PLUGINS
# ------------------------------------------------------------
# zsh-autosuggestions (Pacman installed)
if [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
fi

# zsh-syntax-highlighting (Pacman installed) MUST BE LAST
if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -alF'
alias l='ls -CF'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias cls='clear'
alias please='sudo $(fc -ln -1)'
alias cat='bat'

# Safer rm/mv/cp
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

#install and remove
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
