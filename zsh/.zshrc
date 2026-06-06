# Custom small zshrc

# Environment Variables
source ~/.config/zsh/env
# Aliases
source ~/.config/zsh/aliases

# Set nvim to default editor
export EDITOR='nvim'

# Colors
autoload -U colors && colors
typeset -A ZSH_HIGHLIGHT_STYLES

# Lambda to keep colors local 
function() {
    local PASTEL_PURPLE='#C9B6E3'
    local PASTEL_PINK='#F3C7D6'
    local PASTEL_MINT='#C7EAD9'
    local PASTEL_PEACH='#FFD8B1'
    local PASTEL_BLUE='#BEE5F9'

    # Prompt
    PS1="[%F{${PASTEL_PURPLE}}%n%f@%F{${PASTEL_PINK}}%m%f] %F{${PASTEL_MINT}}%1~%f "

    # Syntax Highlighting Colors
    ZSH_HIGHLIGHT_STYLES[command]='fg='$PASTEL_BLUE
    ZSH_HIGHLIGHT_STYLES[builtin]='fg='$PASTEL_BLUE
    ZSH_HIGHLIGHT_STYLES[function]='fg='$PASTEL_BLUE
    ZSH_HIGHLIGHT_STYLES[alias]='fg='$PASTEL_BLUE
}

# Enable VI keybinds
bindkey -v
export KEYTIMEOUT=1

# Escape with JK
bindkey -M viins 'jk' vi-cmd-mode

# Change cursor shape for different vi modes.
#SOURCE_BEGIN https://github.com/LukeSmithxyz/voidrice/blob/master/.config/zsh/.zshrc
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' '^ulfcd\n'

bindkey -s '^a' '^ubc -lq\n'

bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete
# SOURCE_END

# Disable beep
unsetopt BEEP

# History
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST 

# Basic directory bookmarking
alias bkmrk='cat ~/.bookmarks | fzf'
alias bkmrka='grep -xqF "$(pwd)" ~/.bookmarks || pwd >> ~/.bookmarks' # Append working directory as bookmark
alias bkmrkd='sed -i "\|$(pwd)|d" ~/.bookmarks' # Drop working directory as bookmark 

# Completion
setopt MENU_COMPLETE
bindkey '^[[Z' reverse-menu-complete

# Required for fzf-tab
autoload -U compinit; compinit

# Libraries
source /usr/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/fzf-tab/fzf-tab.zsh
