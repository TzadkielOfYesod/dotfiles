# Custom small zshrc

# Set nvim to default editor
export EDITOR='nvim'

# Colors
autoload -U colors && colors
PASTEL_PURPLE=#C9B6E3
PASTEL_PINK=#F3C7D6
PASTEL_MINT=#C7EAD9
PASTEL_PEACH=#FFD8B
PASTEL_BLUE=#BEE5F9

# Prompt
PS1="[%F{${PASTEL_PURPLE}}%n%f@%F{${PASTEL_PINK}}%m%f] %F{${PASTEL_MINT}}%1~%f "

# Syntax Highlighting Colors
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg='$PASTEL_BLUE
ZSH_HIGHLIGHT_STYLES[builtin]='fg='$PASTEL_BLUE
ZSH_HIGHLIGHT_STYLES[function]='fg='$PASTEL_BLUE
ZSH_HIGHLIGHT_STYLES[alias]='fg='$PASTEL_BLUE

# Enable VI keybinds
bindkey -v
export KEYTEOUT=1

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

# Aliases
alias vim='nvim'

# Disable beep
unsetopt BEEP

# History
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Libraries
source /usr/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
