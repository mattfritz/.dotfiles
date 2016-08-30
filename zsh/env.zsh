# Homebrew
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH

# Rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Node
export NVM_DIR="$HOME/.nvm"
source $(brew --prefix nvm)/nvm.sh

# Golang
export GOPATH="$HOME/src/golang"
export PATH="$GOPATH/bin:$PATH"

# Docker
eval "$(docker-machine env default)"

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"

# Gradle
export GRADLE_OPTS="-Dorg.gradle.daemon=true"

# AWS
source /usr/local/bin/aws_zsh_completer.sh
