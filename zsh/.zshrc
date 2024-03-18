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
export EDITOR=nvim
# export TERM=alacritty



# plugs
source ~/bin/zsh/powerlevel10k/powerlevel10k.zsh-theme
source ~/bin/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/bin/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/bin/zsh/fzf-tab/fzf-tab.zsh
eval "$(lua5.3 ~/bin/zsh/z.lua/z.lua --init zsh enhanced once echo)"

# alias
# alias d="startx"
# alias ":q"="exit"

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


# status
alias s="fastfetch"
alias n="neofetch"

# cli
alias l="ls -l"
alias ll="ls -la"
# alias hotspot="pkexec create_ap wlan0 lo 'Hiraeth' 'wyz2024zxc'"
# alias weather="curl 'v2d.wttr.in/Beijing'"
# alias tran="trans -I -e bing :zh-CN"
# alias dict="trans -d -e bing :zh-CN"
alias ho="hexo clean ; hexo g ; hexo s -o"
alias h="hexo clean ; hexo g ; hexo s"
# alias cat="bat"
# alias renet="sudo systemctl restart NetworkManager"


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
# End of lines added by compinstall


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
