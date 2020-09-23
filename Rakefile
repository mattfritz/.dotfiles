ENV['HOMEBREW_CASK_OPTS'] = "--appdir=/Applications"
DEFAULT_RUBY_VERSION = '2.3.0'
DEFAULT_NODE_VERSION = '5'

require 'rake'
require 'fileutils'
require File.join(File.dirname(__FILE__), 'bin', 'installer', 'vundle')

desc "Installs dotfiles and applications"
task :install do
  puts
  puts "======================================================"
  puts "Installing..."
  puts "======================================================"
  puts

  check_prerequisites
  install_homebrew
  setup_git_keychain

  install_files(Dir.glob('links/*'))
  install_files(['zsh/'])
  install_files(['vim/'])
  # TODO: install an ssh config

  install_vundle
  install_prezto
  install_tmux_powerline
  install_powerlevel9k

  run_osx_customization
  set_default_shell

  success_msg("complete")
end

task :default => 'install'


private
def run(cmd)
  puts "[Running] #{cmd}"
  `#{cmd}` unless ENV['DEBUG']
end

def check_prerequisites
  unless RUBY_PLATFORM.downcase.include?("darwin")
    stderr.puts "Darwin only, for now" && return
  end

  unless system('xcode-select -p')
    $stderr.puts "Please install XCode command-line tools with `xcode-select --install` before proceeding"
    fail
  end
end

def number_of_cores
  if RUBY_PLATFORM.downcase.include?("darwin")
    cores = run %{ sysctl -n hw.ncpu }
  else
    cores = run %{ nproc }
  end
  puts
  cores.to_i
end

def setup_git_keychain
  if system('git credential-osxkeychain').nil?
    puts "======================================================"
    puts "Configuring Git for OSX Keychain"
    puts "\e[32mThis will require sudo privileges\e[0m"
    puts "======================================================"
    run %{
      curl -s -O https://github-media-downloads.s3.amazonaws.com/osx/git-credential-osxkeychain
      chmod u+x git-credential-osxkeychain
      sudo mv git-credential-osxkeychain "$(dirname $(which git))/git-credential-osxkeychain"
    }
  end
end

def install_tmux_powerline
  puts "======================================================"
  puts "Installing tmux-powerline"
  puts "======================================================"

  powerline_path = File.join('tmux', 'tmux-powerline')
  unless File.exists?(powerline_path)
    run %{
      cd $HOME/.dotfiles
      git clone https://github.com/erikw/tmux-powerline.git #{powerline_path}
      cp -f tmux/dotfiles_theme.sh #{powerline_path}/themes
    }
  end
end

def install_powerlevel9k
  puts "======================================================"
  puts "Installing powerlevel9k tmux theme"
  puts "======================================================"

  zprezto_modules_path = '~/.zprezto/modules/prompt'
  run %{
    git clone https://github.com/bhilburn/powerlevel9k.git  #{zprezto_modules_path}/external/powerlevel9k
    ln -s #{zprezto_modules_path}/external/powerlevel9k/powerlevel9k.zsh-theme #{zprezto_modules_path}/functions/prompt_powerlevel9k_setup
  }
end

def run_bundle_config
  return unless system("which bundle")

  bundler_jobs = number_of_cores - 1
  puts "======================================================"
  puts "Configuring Bundler for parallel gem installation"
  puts "======================================================"
  run %{ bundle config --global jobs #{bundler_jobs} }
  puts
end

def run_osx_customization
  puts "======================================================"
  puts "Configuring OSX with sane defaults"
  puts "======================================================"
  osx_path = File.join('bin', 'osx')
  if File.exists?(osx_path)
    run %{ ./#{osx_path} }
  end
end
def install_homebrew
  run %{which brew}
  unless $?.success?
    puts "======================================================"
    puts "Installing Homebrew, the OSX package manager...If it's"
    puts "already installed, this will do nothing."
    puts "======================================================"
    # TODO: prompt for sudo
    run %{ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"}
  end

  puts
  puts
  puts "======================================================"
  puts "Updating Homebrew."
  puts "======================================================"
  run %{brew update}
  puts
  puts
  puts "======================================================"
  puts "Installing Homebrew packages...There may be some warnings."
  puts "======================================================"

  # TODO: add github token to avoid rate limits
  #run %{brew tap caskroom/cask}
  #run %{brew tap homebrew/dupes}

  # TODO: ask for sudo pass
  #run %{brew install Caskroom/cask/java}
  ruby_build_deps = ['openssl', 'libyaml', 'libffi'].join(' ')
  package_list = [
    #'android-sdk',
    #'brew-cask',
    #'chromedriver',
    'ctags',
    #'docker', 'docker-machine', 'docker-compose',
    #'elixir',
    #'exercism',
    'fasd',
    'git',
    'go',
    #'grip',
    #'heroku',
    'hub',
    'jq',
    #'mongodb',
    'nvm',
    #'rbenv', 'rbenv-binstubs', 'ruby-build',
    #'readline',
    'reattach-to-user-namespace',
    'postgresql',
    #'selenium-server-standalone',
    'the_silver_searcher',
    'tmux',
    'tree',
    #'Caskroom/cask/virtualbox',
    'zsh',
    'neovim'
  ].join(' ')

  # TODO: ask for sudo pass
  run %{brew install #{ruby_build_deps} #{package_list}}
  run %{brew install grep --with-default-names}
  # TODO: install full xcode first
  # run %{brew install macvim --override-system-vi --with-lua --with-luajit}
  puts
  puts

  puts "======================================================"
  puts "Installing Homebrew casks...There may be some warnings."
  puts "======================================================"
  cask_list = [
    'android-studio-canary',
    'caffeine',
    'dashlane',
    'evernote',
    'firefoxdeveloperedition',
    'google-chrome',
    'iterm2',
    'seil',
    'slack',
    'spotify',
  ].join(' ')

  run %{brew cask install --binarydir=$(brew --prefix)/bin #{cask_list}}

  puts
  puts
end

def install_fonts
  puts "======================================================"
  puts "Installing patched fonts for Powerline"
  puts "======================================================"
  run %{ cp -f $HOME/.dotfiles/fonts/* $HOME/Library/Fonts }
  run %{ mkdir -p ~/.fonts && cp ~/.dotfiles/fonts/* ~/.fonts && fc-cache -vf ~/.fonts }
  puts
end

def install_prezto
  puts "======================================================"
  puts "Installing Prezto"
  puts "======================================================"

  prezto_path = File.join('zsh', 'prezto')
  unless File.exists?(prezto_path)
    run %{ git clone --recursive https://github.com/sorin-ionescu/prezto.git #{prezto_path} }
  end
  # Prezto will be linked in the install task
end

def set_default_shell
  if ENV["SHELL"].include? 'zsh' then
    puts "Zsh is already configured as your shell of choice. Restart your session to load the new settings"
  else
    puts "Setting zsh as your default shell"
    if File.exists?("/usr/local/bin/zsh")
      if File.readlines("/private/etc/shells").grep("/usr/local/bin/zsh").empty?
        puts "Adding zsh to standard shell list"
        run %{ echo "/usr/local/bin/zsh" | sudo tee -a /private/etc/shells }
      end
      run %{ chsh -s /usr/local/bin/zsh }
    else
      run %{ chsh -s /bin/zsh }
    end
  end
end

def install_files(files, method = :symlink)
  files.each do |f|
    file = f.split('/').last
    source = "#{ENV["PWD"]}/#{f}"
    target = "#{ENV["HOME"]}/.#{file}"

    puts "======================#{file}=============================="
    puts "Source: #{source}"
    puts "Target: #{target}"

    if File.exists?(target) && (!File.symlink?(target) || (File.symlink?(target) && File.readlink(target) != source))
      puts "[Overwriting] #{target}...leaving original at #{target}.backup..."
      run %{ mv "$HOME/.#{file}" "$HOME/.#{file}.backup" }
    end

    if method == :symlink
      run %{ ln -nfs "#{source}" "#{target}" }
    else
      run %{ cp -f "#{source}" "#{target}" }
    end

    puts "=========================================================="
    puts
  end
end

def success_msg(action)
  puts "\e[32m"
  puts <<-'DOC'
                       <>                                   
         .-"""-.       ||::::::==========                   
        /=      \      ||::::::==========                   
       |- /~~~\  |     ||::::::==========                   
       |=( '.' ) |     ||================                   
       \__\_=_/__/     ||================                   
        {_______}      ||================                   
      /` *       `'--._||                                   
     /= .     [] .     { >                                  
    /  /|ooo     |`'--'||   THAT'S ONE SMALL STEP FOR MAN   
   (   )\_______/      ||                                   
    \``\/       \      ||   SON OF A BITCH I'M DOWN A CRATER
     `-| ==    \_|     ||                                   
       /         |     ||                                   
      |=   >\  __/     ||                                   
      \   \ |- --|     ||                                   
       \ __| \___/     ||                                   
       _{__} _{__}     ||                                   
      (    )(    )     ||                                   
  ^^~  `"""  `"""  ~^^^~^^~~~^^^~^^^~^^^~^^~^               
  DOC
  puts "\e[1;4;31m"
  puts "Remember to install App Store apps and update terminal theme and fonts."
  puts "Dotfiles installation is #{action}. Please restart your terminal and vim."
  puts "\e[0m"
end

# Debian:
#
# sudo apt-get install \
#   automake autoconf libreadline-dev \
#   libncurses-dev libssl-dev libyaml-dev \
#   libxslt-dev libffi-dev libtool unixodbc-dev
# sudo apt-get install jq tmux autojump fonts-firacode
# pop-os% asdf plugin add tmux
# pop-os% asdf plugin add neovim
# pop-os% asdf plugin add dust
# pop-os% asdf plugin add fd
# pop-os% asdf plugin add fzf
# pop-os% asdf plugin add golang
# pop-os% asdf plugin add hub
# pop-os% asdf plugin add jq
# pop-os% asdf plugin add nodejs
# pop-os% asdf plugin add ruby
# pop-os% asdf plugin add ripgrep
# pop-os% asdf plugin add yq
