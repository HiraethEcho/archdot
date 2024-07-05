# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# export LANGUAGE=zh_CN:en_US
export LANGUAGE=en_US
# export PATH="$HOME/.local/bin:$PATH"
# export PATH="$HOME/.config/dwm/dwm_functions:$HOME/.local/bin:$PATH"
export EDITOR=nvim
# export PAGER=sioyek
export SUDO_ASKPASS="$HOME/.local/bin/rpass"
export TERMINAL=alacritty


export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
# export XDG_RUNTIME_DIR="$HOME/.local/tmp"

export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export _ZL_DATA="$XDG_DATA_HOME/zlua"
export HISTFILE="$XDG_STATE_HOME/zsh/history"

# fcitx5
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx
export INPUT_METHOD=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus


# export LFS=/mnt/lfs

# plugs
source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
eval "$(lua /usr/share/z.lua/z.lua --init zsh enhanced once echo)"

# alias
alias zshrc="nvim ~/.config/zsh/.zshrc"

# alias D="sx exec dwm_old"
alias D="sx exec dwm"
# alias G="sx exec gnome-session"
# alias k="sx exec startplasma-x11"
# alias X="startxfce4"

# tui
alias n="nvim"
alias lazyvim="NVIM_APPNAME=lazyvim nvim"
alias mininvim="NVIM_APPNAME=mini nvim"
alias astro="NVIM_APPNAME=astro nvim"
alias kicknvim="NVIM_APPNAME=kicknvim nvim"

# git
alias gx="git clean -xdf"
alias gl="git log --graph --oneline --decorate --all"
alias gpatch="git format-patch -1"
alias gc="git clone "
alias gc1="git clone --depth 1"

# tmux
alias tn="tmux new -s "
alias ta="tmux attach -t "
alias tl="tmux list"
# alias pad="tmux new -s pad"
# alias tmp="tmux new -s tmp"
# alias blog="tmux new -s blog"
# alias tp="tmux attach -t pad"
# alias tt="tmux attach -t tmp"
# alias tb="tmux attach -t blog"

# snapper

# status
alias s="fastfetch"
# alias B="upower -i /org/freedesktop/UPower/devices/battery_BAT1 "

# cli
alias l="lsd -l"
alias ll="lsd -la"
alias r="ranger"
alias lg="lazygit"
alias zi="z -I"

# usefule tools
alias weather="curl 'v2d.wttr.in/Beijing'"
alias hso="hexo clean ; hexo g ; hexo s -o"
alias hs="hexo clean ; hexo g ; hexo s"
alias sg="sudo grub-mkconfig -o /boot/grub/grub.cfg"

# pacman and yay
alias syyu="paru -Syyu"
alias qdtq="pacman -Qdttq | sudo pacman -Rscn -"
alias Qei="pacman -Qqe | fzf --preview 'pacman -Qiil {}' --layout=reverse --bind 'enter:execute(pacman -Qiil {} | less)'"
alias Qi="pacman -Qq | fzf --preview 'pacman -Qiil {}' --layout=reverse --bind 'enter:execute(pacman -Qiil {} | less)'"
alias Sl="pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse --bind 'enter:execute(pacman -Si {} | less)'"

# double tap Esc to add sudo
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ $BUFFER == $EDITOR\ * ]]; then
        LBUFFER="${LBUFFER#$EDITOR }"
        LBUFFER="sudoedit $LBUFFER"
    elif [[ $BUFFER == sudoedit\ * ]]; then
        LBUFFER="${LBUFFER#sudoedit }"
        LBUFFER="$EDITOR $LBUFFER"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line


# Lines configured by zsh-newuser-install
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/hiraeth/.zshrc'

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION" 
# End of lines added by compinstall

eval "$(mcfly init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
