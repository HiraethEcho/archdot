# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# export ZDOTDIR="$HOME"/.config/zsh
# export LANGUAGE=zh_CN:en_US
export LANGUAGE=en_US
export EDITOR=nvim
# export PAGER=sioyek
# export SUDO_ASKPASS=~/scripts/dpass.sh
export SUDO_ASKPASS=~/scripts/rpass.sh
export TERM=alacritty

export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export HISTFILE="$XDG_STATE_HOME"/zsh/history
export _ZL_DATA="$XDG_DATA_HOME/zlua"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
# export XDG_RUNTIME_DIR="$HOME/.local/tmp"

# export PATH="/usr/bin:/usr/local/bin:$HOME/.local/bin"

# export PATH=/home/hiraeth/.local/share/gem/ruby/3.0.0/bin:$PATH

export LFS=/mnt/lfs

# plugs
source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
eval "$(lua /usr/share/z.lua/z.lua --init zsh enhanced once echo)"

# alias
alias d="sx"
alias "Q"="exit"

# tui
alias r="ranger"
alias lg="lazygit"

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
alias pad="tmux new -s pad"
alias tmp="tmux new -s tmp"
alias blog="tmux new -s blog"
alias tp="tmux attach -t pad"
alias tt="tmux attach -t tmp"
alias tb="tmux attach -t blog"

# snapper
alias sg="sudo grub-mkconfig -o /boot/grub/grub.cfg"

# status
alias s="fastfetch"
alias n="neofetch"
alias B="sudo upower -i /org/freedesktop/UPower/devices/battery_BAT1 "

# cli
alias l="lsd -l"
alias ll="lsd -la"
alias hotspot="pkexec create_ap wlan0 lo 'Hiraeth' 'wyz2024zxc'"
alias weather="curl 'v2d.wttr.in/Beijing'"
alias tran="trans -I -e bing :zh-CN"
alias dict="trans -d -e bing :zh-CN"
alias ho="hexo clean ; hexo g ; hexo s -o"
alias h="hexo clean ; hexo g ; hexo s"
# alias renet="sudo systemctl restart NetworkManager"

# pacman and yay
alias syyu="yay -Syyu"
alias syu="yay -Syu"
alias rcs="sudo pacman -Rcs $(pacman -Qdtq) -"
alias scc="yay -Scc"
alias news="yay -Pww"
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
HISTFILE=~/.histfile
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
