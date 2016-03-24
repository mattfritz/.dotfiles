# Homebrew
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH

# Rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Node
export NVM_DIR="$HOME/.nvm"
source $(brew --prefix nvm)/nvm.sh

# Golang
export PATH=$PATH:/usr/local/opt/go/libexec/bin

# Docker
eval "$(docker-machine env default)"

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"

# Gradle
export GRADLE_OPTS="-Dorg.gradle.daemon=true"
