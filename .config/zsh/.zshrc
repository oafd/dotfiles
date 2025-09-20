set -o vi
# Home/End (works if your terminal sends \e[H / \e[F)
bindkey -M viins '^[[H' beginning-of-line
bindkey -M viins '^[[F' end-of-line
bindkey -M vicmd '^[[H' beginning-of-line
bindkey -M vicmd '^[[F' end-of-line

# Also map Ctrl-A / Ctrl-E in insert mode (handy on mac)
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line

# Option/Alt + Left/Right → word motions (most mac terminals send ESC-b / ESC-f)
bindkey -M viins '^[b' backward-word
bindkey -M viins '^[f' forward-word
bindkey -M vicmd '^[b' backward-word
bindkey -M vicmd '^[f' forward-word

# Some terminals send different sequences for Option+Arrows; cover those too:
bindkey -M viins '^[^[[D' backward-word
bindkey -M viins '^[^[[C' forward-word
bindkey -M vicmd '^[^[[D' backward-word
bindkey -M vicmd '^[^[[C' forward-word
# ─────────────────────────────────────────────────────────────
# Locale & Editor
# ─────────────────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="$EDITOR"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export DOCKER_HOST="unix://${HOME}/.config/colima/default/docker.sock"
export TESTCONTAINERS_RYUK_DISABLED=true
export TESTCONTAINERS_STARTUP_TIMEOUT=120
export SOPS_EDITOR="$EDITOR"

# ─────────────────────────────────────────────────────────────
# Path
# ─────────────────────────────────────────────────────────────
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-indent/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/mysql/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"
export PATH="/opt/homebrew/bn:$PATH"
export PATH="/Applications/IntelliJ IDEA CE.app/Contents/MacOS:$PATH"
export PATH="$PATH:$HOME/.local/bin"

# ─────────────────────────────────────────────────────────────
# FZF & FD
# ─────────────────────────────────────────────────────────────
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
setopt HIST_REDUCE_BLANKS

export FZF_CTRL_T_COMMAND="fd . \$HOME --type f --type d --hidden --color=always | sort"
export FZF_CTRL_T_OPTS="--prompt=' Files > ' \
  --margin=0,2,0,2 \
  --height=70% \
  --header='ctrl-g: Only dirs | ctrl-h: in CWD | ctrl-o: Open in nvim' \
  --bind '?:toggle-preview' \
  --bind 'shift-down:preview-down+preview-down+preview-down+preview-down+preview-down' \
  --bind 'shift-up:preview-up+preview-up+preview-up+preview-up+preview-up' \
  --bind 'ctrl-g:reload(fd --type d --color=always | sort)' \
  --bind 'ctrl-h:reload(fd . --type f --type d --color=always | sort)' \
  --bind 'ctrl-t:reload(fd . \$HOME --type f --type d --color=always | sort)' \
  --bind 'ctrl-o:execute(nvim {+})+abort'"
export FZF_PREVIEW_OPTS="--preview='$HOME/.config/fzf/preview.sh {}' --preview-window=right:50%:wrap"
export FZF_DEFAULT_COMMAND="fd . --type f --type d --hidden --color=always | sort"
export FZF_DEFAULT_OPTS="--style default --margin=0,2,0,2 --tiebreak=begin,index --height=65% --reverse --border --ansi $FZF_PREVIEW_OPTS"
export FZF_ALT_C_COMMAND="fd . --type d --hidden --color=always"
export FZF_ALT_C_OPTS="--prompt=' Directory > ' --margin=0"
export FZF_YAZI_COMMAND="fd . \$HOME --type d --hidden --color=always | sort"
export FZF_CTRL_R_OPTS="--prompt=' History > ' \
  --margin=0,1,0,1 \
  --with-nth=2.. \
  --preview-window=down:40%:wrap \
  --height=15 \
  --exact \
  --preview='echo {} | sed -E \"s/^[[:space:]]*[0-9]+[[:space:]]+//\" | bat --plain --language=bash --color=always --theme=\"Catppuccin Mocha\"'"
export FZF_COMPLETION_TRIGGER='...'
export FZF_COMPLETION_OPTS='--border --info=inline'

# ─────────────────────────────────────────────────────────────
# Zoxide + Yazi Integration
# ─────────────────────────────────────────────────────────────
export YAZI_ZOXIDE_OPTS='--preview "eza -T --git --git-ignore --icons --color=always {2..}" --preview-window=right:50%'
export _ZO_FZF_OPTS="$YAZI_ZOXIDE_OPTS --reverse --margin=0 --border"

# ─────────────────────────────────────────────────────────────
# Tools: PATH-only init (safe for non-interactive)
# ─────────────────────────────────────────────────────────────
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"

# ─────────────────────────────────────────────────────────────
# Oh My Zsh, prompt & completions (INTERACTIVE TTY ONLY)
# ─────────────────────────────────────────────────────────────
if [[ $- == *i* ]] && [[ -t 1 ]]; then
  export ZSH="$HOME/.oh-my-zsh"
  # ZSH_THEME="powerlevel10k/powerlevel10k"
  COMPLETION_WAITING_DOTS="true"
  plugins=(git fzf fzf-tab zsh-autosuggestions zsh-syntax-highlighting)
  source "$ZSH/oh-my-zsh.sh"   # compinit + ZLE widgets

  # Kubectl completion (after OMZ so compinit is ready)
  if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
    alias k=kubectl
    compdef __start_kubectl k
  fi

  # Angular CLI completion
  if command -v ng >/dev/null 2>&1; then
    source <(ng completion script)
  fi

  # fzf-tab preview style (ZLE context)
  zstyle ':fzf-tab:complete:env:*' fzf-preview '
    local varname="${(s/=/)word}[1]"
    print -r -- "${(P)varname}"
  '

  # Prompt & widgets
  eval "$(starship init zsh)"
  eval "$(zoxide init zsh --cmd cd)"
  # eval "$(atuin init zsh --disable-up-arrow --disable-ctrl-r)"
fi

# ─────────────────────────────────────────────────────────────
# Node Version Manager
# ─────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
nvm_lazy_load() {
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
  unset -f node npm npx nvm_lazy_load
}
for cmd in node npm npx; do
  eval "${cmd}() { nvm_lazy_load; ${cmd} \"\$@\"; }"
done

# ─────────────────────────────────────────────────────────────
# Appearance
# ─────────────────────────────────────────────────────────────
export XDG_CONFIG_HOME="$HOME/.config"
export BAT_THEME="Catppuccin Mocha"
export LS_COLORS="$(vivid generate catppuccin-mocha)"

# ─────────────────────────────────────────────────────────────
# Aliases
# ─────────────────────────────────────────────────────────────
alias cat="bat --style=plain --paging=never"
alias catjson='sed -e '\''s/\\n/\n    /g'\'' -e '\''s/\\tat/    at/g'\'' -e '\''s/\\t/    /g'\'' | cat -l json --paging=never'
alias color='pastel color'
alias colores='pastel list'
alias cp='cp -vi'
alias j11="export JAVA_HOME=`/usr/libexec/java_home -v 11`; java -version"
alias j17="export JAVA_HOME=`/usr/libexec/java_home -v 17`; java -version"
alias j21="export JAVA_HOME=`/usr/libexec/java_home -v 21`; java -version"
alias j22="export JAVA_HOME=`/usr/libexec/java_home -v 22`; java -version"
alias j8="export JAVA_HOME=`/usr/libexec/java_home -v 1.8`; java -version"
alias jqkeys="jq 'keys_unsorted[]' | sort -u"
alias jqs='jq -R -r "fromjson? | select(.)"'
alias jvv="/usr/libexec/java_home -V"
alias kctx="kubectx | fzf | xargs kubectx"
alias kk='kubectl'
alias kns="kubens | fzf | xargs kubens"
alias intellij='open -a "IntelliJ IDEA CE" .'
alias ll='lazygit'
alias ls='eza --oneline --icons --color=always'
alias m='nvim'
alias man='batman'
alias mv='mv -vi'
alias ncdu="ncdu --color dark"
alias raycast='open -a "Raycast"'
alias top='btm'
alias wget='wget2'
alias yy='yazi'

# ─────────────────────────────────────────────────────────────
# Custom Functions
# ─────────────────────────────────────────────────────────────
source "$HOME/.config/fzf/custom-functions.sh"

# Compile .zshrc if not already compiled
[[ -s ~/.config/zsh/.zshrc.zwc ]] || zcompile ~/.config/zsh/.zshrc
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

