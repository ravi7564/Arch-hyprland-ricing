alias btop="btop --force-utf"
alias update="sudo pacman -Sy"
alias upgrade="sudo pacman -Syu"

# --- 1. P10k Instant Prompt ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

# --- 2. DISABLE DEFAULT TITLES (Important!) ---
# This stops Oh My Zsh from forcing "user@hostname" into the tab
DISABLE_AUTO_TITLE="true"

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# --- 3. CUSTOM "EMPTY" TAB LOGIC (Must be at the very end) ---
# This forces the tab title to be "EMPTY" when idle, and the command name when running.

case $TERM in
  xterm*|rxvt*|kitty*)
    # When the shell is waiting (IDLE) -> Set title to EMPTY
    precmd() {
      print -Pn "\e]0;EMPTY\a"
    }
    
    # When running a command (ACTIVE) -> Set title to command name (e.g. vim)
    preexec() {
      print -Pn "\e]0;$1\a"
    }
    ;;
esac
