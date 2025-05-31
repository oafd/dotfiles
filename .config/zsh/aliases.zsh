alias cat="bat --style=plain --paging=never"
alias yy='yazi'
alias m='nvim'
alias ll='lazygit'
alias top='btm'
alias wget='wget2'
alias mv='mv -vi'
alias cp='cp -vi'
alias color='pastel color'
alias jqs='jq -R -r "fromjson? | select(.)"'
alias colores='pastel list'
alias ls='eza --oneline --icons --color=always'
alias kctx="kubectx | fzf | xargs kubectx"
alias kns="kubens | fzf | xargs kubens"
alias man='batman'
alias cadd='chezmoi add'
alias cedit='chezmoi edit'
alias capply='chezmoi apply'
alias cdot='cd ~/.local/share/chezmoi'
alias dotpush='cdot && git add . && git commit -m "Update dotfiles" && git push'
alias j22="export JAVA_HOME=`/usr/libexec/java_home -v 22`; java -version"
alias j21="export JAVA_HOME=`/usr/libexec/java_home -v 21`; java -version"
alias j17="export JAVA_HOME=`/usr/libexec/java_home -v 17`; java -version"
alias j11="export JAVA_HOME=`/usr/libexec/java_home -v 11`; java -version"
alias j8="export JAVA_HOME=`/usr/libexec/java_home -v 1.8`; java -version"
alias jvv="/usr/libexec/java_home -V"
