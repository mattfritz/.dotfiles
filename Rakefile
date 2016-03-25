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

  install_fonts
  install_term_theme

  run_osx_customization
  set_default_shell

  setup_ruby
  run_bundle_config
  setup_node

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
    $stderr.puts "Darwin only, for now" && return
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

def setup_ruby
  puts "======================================================"
  puts "Installing Ruby"
  puts "======================================================"
  run %{
    rbenv install #{DEFAULT_RUBY_VERSION}
    rbenv global #{DEFAULT_RUBY_VERSION}
    gem install gem-ctags
    rbenv rehash
    gem ctags
  }
end

def setup_node
  puts "======================================================"
  puts "Installing Node"
  puts "======================================================"
  run %{ nvm install #{DEFAULT_NODE_VERSION} }
end

def install_vundle
  puts "======================================================"
  puts "Installing and updating vundles."
  puts "The installer will now run PluginInstall to install vundles."
  puts "======================================================"

  puts ""

  vundle_path = File.join('vim','bundle', 'Vundle.vim')
  unless File.exists?(vundle_path)
    run %{
      cd $HOME/.dotfiles
      git clone https://github.com/VundleVim/Vundle.vim.git #{vundle_path}
    }
  end

  Vundle::update_vundle
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

  ruby_build_deps = ['openssl', 'libyaml', 'libffi'].join(' ')
  package_list = [
    'android-sdk',
    'brew-cask',
    'chromedriver',
    'ctags',
    'docker', 'docker-machine', 'docker-compose',
    'elixir',
    'exercism',
    'fasd',
    'git',
    'go',
    'heroku-toolbelt',
    'hub',
    'jq',
    'mongodb',
    'nvm',
    'rbenv', 'rbenv-binstubs', 'ruby-build',
    'readline',
    'reattach-to-user-namespace',
    'postgresql',
    'selenium-server-standalone',
    'the_silver_searcher',
    'tmux',
    'tree',
    'virtualbox',
    'zsh',
  ].join(' ')

  run %{brew install #{ruby_build_deps} #{package_list}}
  run %{brew install grep --with-default-names}
  run %{brew install vim --override-system-vi --with-lua --with-luajit}
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

def install_term_theme
  puts "======================================================"
  puts "Installing iTerm2 themes"
  puts "======================================================"

  run %{ /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Dotfiles Theme' dict" ~/Library/Preferences/com.googlecode.iterm2.plist }
  run %{ /usr/libexec/PlistBuddy -c "Merge 'iterm/dark_theme.itermcolors' :'Custom Color Presets':'Dotfiles Theme'" ~/Library/Preferences/com.googlecode.iterm2.plist }

  # If iTerm2 is not installed or has never run, we can't autoinstall the profile since the plist is not there
  if !File.exists?(File.join(ENV['HOME'], '/Library/Preferences/com.googlecode.iterm2.plist'))
    puts "======================================================"
    puts "To make sure your profile is using the dark theme"
    puts "Please check your settings under:"
    puts "Preferences> Profiles> [your profile]> Colors> Load Preset.."
    puts "======================================================"
    return
  end

  color_scheme_file = File.join('iterm', "dark_theme.itermcolors")
  profiles = iTerm_profile_list
  profiles << 'All'

  (profiles.size-1).times { |idx| apply_theme_to_iterm_profile_idx idx, color_scheme_file }
end

def iTerm_profile_list
  profiles=Array.new
  begin
    profiles <<  %x{ /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':#{profiles.size}:Name" ~/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null}
  end while $?.exitstatus==0
  profiles.pop
  profiles
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

def apply_theme_to_iterm_profile_idx(index, color_scheme_path)
  values = Array.new
  16.times { |i| values << "Ansi #{i} Color" }
  values << ['Background Color', 'Bold Color', 'Cursor Color', 'Cursor Text Color', 'Foreground Color', 'Selected Text Color', 'Selection Color']
  values.flatten.each { |entry| run %{ /usr/libexec/PlistBuddy -c "Delete :'New Bookmarks':#{index}:'#{entry}'" ~/Library/Preferences/com.googlecode.iterm2.plist } }

  run %{ /usr/libexec/PlistBuddy -c "Merge '#{color_scheme_path}' :'New Bookmarks':#{index}" ~/Library/Preferences/com.googlecode.iterm2.plist }
  run %{ defaults read com.googlecode.iterm2 }
end

# TODO: Find a good asciiart
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
