# ----- initial setup -------------------------------------------------------

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# auto start tmux only when sshing
if [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then
    exec tmux new-session -A -s main
fi

# ----- initial setup -------------------------------------------------------


# ----- power10k auto-gen conf ----------------------------------------------

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ----- power10k auto-gen conf ----------------------------------------------


# ----- Zinit setup ---------------------------------------------------------
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# ----- Zinit setup ---------------------------------------------------------


# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh


# ----- plugins and snippets -------------------------------------------------

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found
zinit snippet OMZP::alias-finder
zinit snippet OMZP::tailscale

# ----- plugins and snippets -------------------------------------------------


# ----- completion setup -----------------------------------------------------

# Load completions
autoload -Uz compinit && compinit
_comp_options+=(globdots)		# Include hidden files.
zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ----- completion setup -----------------------------------------------------


# ----- keybinds and functions setup -----------------------------------------

# Keybinds
bindkey -v
export KEYTIMEOUT=1
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Functions
fzf_nvim_open() {
  local selected
  selected=$(fd --type f --hidden --follow --exclude .git | fzf --preview 'bat --color=always {}' --border)
  if [[ -n "$selected" ]]; then
    nvim "$selected"
  fi
  zle reset-prompt
}

zle -N fzf_nvim_open
bindkey '^F' fzf_nvim_open

# ----- keybinds and functions setup -----------------------------------------


# ----- History setup --------------------------------------------------------

HISTSIZE=10000
HISTFILE=~/.cache/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ----- History setup --------------------------------------------------------


# ----- cursor setup ---------------------------------------------------------

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# ----- cursor setup ---------------------------------------------------------


# ----- alias setup ----------------------------------------------------------

alias ls='ls --color'
alias grep='grep --color=auto'
alias v='nvim'

alias l="exa --sort Name"
alias ll="exa --sort Name --long"
alias la="exa --sort Name --long --all"
alias lr="exa --sort Name --long --recurse"
alias lra="exa --sort Name --long --recurse --all"
alias lt="exa --sort Name --long --tree"
alias lta="exa --sort Name --long --tree --all"


# ----- alias setup ----------------------------------------------------------

# ----- Shell integrations ---------------------------------------------------

eval "$(fzf --zsh)"

# ----- Shell integrations ---------------------------------------------------
