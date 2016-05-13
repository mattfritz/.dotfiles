alias ll='ls -alGh'
alias ls='ls -Gh'

# PS
alias psa="ps aux"
alias psg="ps aux | grep "

# Moving around
alias cdb='cd -'
alias cdl='ll $1; cd $1'
alias cls='clear;ls'

# Show human friendly numbers and colors
alias df='df -h'
alias du='du -h -d 2'

# show me files matching "ls grep"
alias lsg='ll | grep'

# Git Aliases
alias g='git'
alias gs='git status'
alias gst='git stash'
alias gsp='git stash pop'
alias gsa='git stash apply'
alias gsh='git show'
alias gshw='git show'
alias gshow='git show'
alias gcm='git ci -m'
alias gco='git co'
alias ga='git add -A'
alias gap='git add -p'
alias gus='git unstage'
alias guc='git uncommit'
alias gm='git merge'
alias gms='git merge --squash'
alias gam='git amend --reset-author'
alias grv='git remote -v'
alias grr='git remote rm'
alias grad='git remote add'
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gri='git rebase --interactive'
alias gl='git l'
alias gf='git fetch'
alias gd='git diff'
alias gb='git b'
alias gbd='git b -D -w'
alias gdc='git diff --cached -w'
alias gds='git diff --staged -w'
alias gpl='git pull --rebase'
alias gp='git push'
alias gps='git push -u origin `git rev-parse --abbrev-ref HEAD`'
alias gnb='git nb' # new branch aka checkout -b
alias grs='git reset'
alias grsh='git reset --hard'
alias gcln='git clean'
alias gclndf='git clean -df'
alias gclndfx='git clean -dfx'
alias gsm='git submodule'
alias gsmi='git submodule init'
alias gsmu='git submodule update'
alias gt='git t'
alias gbg='git bisect good'
alias gbb='git bisect bad'
alias gdmb='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'

# Common shell functions
alias less='less -r'
alias t='tail -f'
alias l='less'
alias lh='ls -alt | head' # see the last modified files

# Zippin
alias gz='tar -zcvf'

# Ruby
alias rdm='rake db:migrate'
alias rdmr='rake db:migrate:redo'

alias hpr='hub pull-request'

# Finder
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# Homebrew
alias brewu='brew update && brew upgrade --all && brew cleanup && brew prune && brew doctor'

# Vim
alias vim='mvim -v'
alias v='mvim -v'
alias vp='mvim -v -p'
alias vo='mvim -v -O'

# Tmux
alias ta='tmux attach -t'
alias tn='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'
