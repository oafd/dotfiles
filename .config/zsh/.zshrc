# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# ─────────────────────────────────────────────────────────────
# Locale & Editor
# ─────────────────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
# ─────────────────────────────────────────────────────────────
# Path
# ─────────────────────────────────────────────────────────────
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-indent/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/mysql/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"
export PATH="/opt/homebrew/bn:$PATH"
export PATH="$PATH:$HOME/.local/bin"

# ─────────────────────────────────────────────────────────────
# FZF & FD
# ─────────────────────────────────────────────────────────────
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
export FZF_DEFAULT_OPTS_1=" \
--color=spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=border:#313244,label:#CDD6F4"
export FZF_PREVIEW_OPTS="--preview='$HOME/.config/fzf/preview.sh {}' --preview-window=right:50%:wrap"
export FZF_DEFAULT_COMMAND="fd . --type f --type d --hidden --color=always | sort"
export FZF_DEFAULT_OPTS="--margin=0,2,0,2 --tiebreak=begin,index --height=65% --reverse --border --ansi --no-mouse $FZF_PREVIEW_OPTS $FZF_DEFAULT_OPTS_1"
export FZF_CTRL_T_COMMAND="fd . \$HOME --type f --type d --hidden --color=always | sort"
export FZF_CTRL_T_OPTS="--prompt=' Files > ' --margin=0,2,0,2 --height=70% --bind shift-up:preview-page-up,shift-down:preview-page-down"
export FZF_ALT_C_COMMAND="fd . --type d --hidden --color=always"
export FZF_ALT_C_OPTS="--prompt=' Directory > ' --margin=0"
export FZF_YAZI_COMMAND="fd . \$HOME --type d --hidden --color=always | sort"
export FZF_CTRL_R_OPTS="--prompt=' History > ' --margin=0,3,0,3 --with-nth=2.. --preview-window=down:20%:wrap --height=45% --preview='echo {} | bat --plain --language=bash --color=always --theme=\"Catppuccin Mocha\"'"
export FZF_COMPLETION_TRIGGER='...'

# ─────────────────────────────────────────────────────────────
# Zoxide + Yazi Integration
# ─────────────────────────────────────────────────────────────
export YAZI_ZOXIDE_OPTS='--preview "eza -T --git --git-ignore --icons --color=always {2..}" --preview-window=right:50%'
export _ZO_FZF_OPTS="$YAZI_ZOXIDE_OPTS --reverse --margin=0 --border"

# ─────────────────────────────────────────────────────────────
# Oh My Zsh & Plugins
# ─────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
COMPLETION_WAITING_DOTS="true"
plugins=(git fzf fzf-tab zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"

# ─────────────────────────────────────────────────────────────
# Tools & Shell Enhancements
# ─────────────────────────────────────────────────────────────
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
# eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd cd)"
eval "$(atuin init zsh --disable-up-arrow --disable-ctrl-r)"
source <(ng completion script)

# ─────────────────────────────────────────────────────────────
# Node Version Manager
# ─────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# ─────────────────────────────────────────────────────────────
# Appearance & Aliases
# ─────────────────────────────────────────────────────────────
export XDG_CONFIG_HOME="$HOME/.config"
export BAT_THEME="Catppuccin Mocha"
export LS_COLORS="$(vivid generate catppuccin-mocha)"
source "$ZDOTDIR/aliases.zsh"

# ─────────────────────────────────────────────────────────────
# Custom Functions
# ─────────────────────────────────────────────────────────────
source "$HOME/.config/fzf/custom-functions.sh"
# Compile .zshrc if not already compiled
[[ -s ~/.config/zsh/.zshrc.zwc ]] || zcompile ~/.config/zsh/.zshrc
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
