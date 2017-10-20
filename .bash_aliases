# .bash_aliases

alias ll='ls -l --human-readable --color=auto'
alias la='ls -l --human-readable --color=auto --almost-all'
alias dirs='command dirs -v'

git_current_branch() {
  cat "$(git rev-parse --git-dir 2>/dev/null)/HEAD" | sed -e 's/^.*refs\/heads\///'
}
alias glog='git log --date-order --pretty="format:%C(yellow)%h%Cgreen%d%Creset %s %C(cyan) %an, %ar%Creset"'
alias gl='glog --graph'
alias gla='gl --all'
alias glo='gl HEAD origin/$(git_current_branch)'