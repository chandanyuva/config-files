# ----- initial setup -------------------------------------------------------

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [[ "$TERM" == "xterm-kitty" && -n "$SSH_CONNECTION" ]]; then
  export TERM=tmux-256color
fi

# Detect WSL
is_wsl=false
grep -qi microsoft /proc/version 2>/dev/null && is_wsl=true

# auto start tmux only when sshing and in wsl
if [[ -z "$TMUX" && ( -n "$SSH_TTY" || "$is_wsl" == true ) ]]; then
    if tmux has-session 2>/dev/null; then
        exec tmux attach-session
    else
        exec tmux new-session -s main
    fi
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
zinit ice wait lucid; zinit light zsh-users/zsh-completions
zinit ice wait lucid; zinit light zsh-users/zsh-autosuggestions
zinit ice wait lucid atload"zicompinit; zicdreplay"; zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting  # must be last, sync

# Add in snippets
zinit ice wait lucid
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# ----- plugins and snippets -------------------------------------------------


# ----- completion setup -----------------------------------------------------

# Load completions (only rebuild if older than 24h)
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.config/zsh/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
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
bindkey '^[[1;3D' backward-word  # Alt+Left
bindkey '^[[1;3C' forward-word   # Alt+Right

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

zathura_finder() {
    fzf-pdf-zathura   # script in bin
    zle reset-prompt
}

zle -N zathura_finder
bindkey '^P' zathura_finder

# Fuzzy in-file search (ripgrep + fzf)
fif() {
  if [[ -n "$1" ]]; then
    local dir="${2:-.}"
    rg --files-with-matches --no-messages "$1" "$dir" | fzf \
      --preview "rg --pretty --color always --context 5 --max-columns 200 -C 5 '$1' {}" \
      --border
  fi
}

# Print PATH one entry per line
path() {
  echo -e ${PATH//:/\\n}
}

# ----- keybinds and functions setup -----------------------------------------


# ----- History setup --------------------------------------------------------

HISTSIZE=50000
HISTFILE=~/.cache/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
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

alias l="eza --sort Name --icons"
alias ll="eza --sort Name --long --icons"
alias la="eza --sort Name --long --all --icons"
alias lr="eza --sort Name --long --recurse --icons"
alias lra="eza --sort Name --long --recurse --all --icons"
alias lt="eza --sort Name --long --tree --icons"
alias lta="eza --sort Name --long --tree --all --icons"

alias lzg="lazygit"
alias lzd="lazydocker"

# ----- alias setup ----------------------------------------------------------

# ----- Shell integrations ---------------------------------------------------

eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# Clean stale zsh cache files
zsh_clean() {
  echo "Cleaning .zcompdump files older than 7 days..."
  find "${ZDOTDIR:-$HOME/.config/zsh}" -name '.zcompdump*' -mtime +7 -delete 2>/dev/null
  echo "Purging stale zinit plugins..."
  zinit delete --clean 2>/dev/null
  echo "Done."
}

# ----- Shell integrations ---------------------------------------------------


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/chandan/projects/youtube-clone-fullstack/google-cloud-sdk/path.zsh.inc' ]; then . '/home/chandan/projects/youtube-clone-fullstack/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/chandan/projects/youtube-clone-fullstack/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/chandan/projects/youtube-clone-fullstack/google-cloud-sdk/completion.zsh.inc'; fi
