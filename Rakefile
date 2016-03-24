ENV['HOMEBREW_CASK_OPTS'] = "--appdir=/Applications"

require 'rake'
require 'fileutils'
require File.join(File.dirname(__FILE__), 'bin', 'installer', 'vundle')

desc "Installs dotfiles and applications"
task :install => [:submodule_init, :submodules] do
  puts
  puts "======================================================"
  puts "Installing..."
  puts "======================================================"
  puts

  unless RUBY_PLATFORM.downcase.include?("darwin")
    $stderr.puts "Darwin only, for now" && return
  end

  # TODO: install xcode command line tools
  install_homebrew

  # TODO: set up git keychain helper
  # TODO: install heroku build tools and plugins
  # TODO: INSTALL RBENV + BINSTUBS from https://github.com/ianheggie/rbenv-binstubs.git
  # setup_rbenv
  #
  # TODO: install actual applications (Chrome, etc)

  # this has all the runcoms from this directory.
  install_files(Dir.glob('links/*'))
  # TODO: make sure this works with directories
  install_files(['zsh/'])
  # TODO: add these vim configs to the repo with customizations https://github.com/timthrillist/minimum-awesome.git
  install_files(Dir.glob('vim/'))

  Rake::Task["install_vundle"].execute
  # TODO: add submodules for these
  # install_prezto
  # Rake::Task["install_tmux_powerline"].execute

  # TODO: add font to folder and update this task
  # install_fonts

  # TODO: include theme and hardcode
  # install_term_theme

  run_bundle_config

  success_msg("installed")
end

desc "Initialize submodules"
task :submodule_init do
  run %{ git submodule update --init --recursive }
end

desc "Update submodules"
task :submodules do
  puts "======================================================"
  puts "Downloading submodules...please wait"
  puts "======================================================"

  run %{
    cd $HOME/.dotfiles
    git submodule update --recursive
    git clean -df
  }
  puts
end

desc "Performs migration from pathogen to vundle"
task :vundle_migration do
  puts "======================================================"
  puts "Migrating from pathogen to vundle vim plugin manager. "
  puts "This will move the old .vim/bundle directory to"
  puts ".vim/bundle.old and replacing all your vim plugins with"
  puts "the standard set of plugins. You will then be able to "
  puts "manage your vim's plugin configuration by editing the "
  puts "file .vimrc.bundles"
  puts "======================================================"

  Dir.glob(File.join('vim', 'bundle','**')) do |sub_path|
    run %{git config -f #{File.join('.git', 'config')} --remove-section submodule.#{sub_path}}
    # `git rm --cached #{sub_path}`
    FileUtils.rm_rf(File.join('.git', 'modules', sub_path))
  end
  FileUtils.mv(File.join('vim','bundle'), File.join('vim', 'bundle.old'))
end

desc "Runs Vundle installer in a clean vim environment"
task :install_vundle do
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

task :default => 'install'


private
def run(cmd)
  puts "[Running] #{cmd}"
  `#{cmd}` unless ENV['DEBUG']
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

def run_bundle_config
  return unless system("which bundle")

  bundler_jobs = number_of_cores - 1
  puts "======================================================"
  puts "Configuring Bundler for parallel gem installation"
  puts "======================================================"
  run %{ bundle config --global jobs #{bundler_jobs} }
  puts
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
    'brew-cask',
    'chromedriver',
    'ctags',
    'elixir',
    'exercism',
    'fasd',
    'git',
    'go',
    'hub',
    'jq',
    'mongodb',
    'nvm',
    'rbenv',
    'readline',
    'reattach-to-user-namespace',
    'mpg123',
    'mysql',
    'phantomjs',
    'postgresql',
    'selenium-server-standalone',
    'the-silver-searcher',
    'tmux',
    'tree',
    'zsh',
  ].join(' ')

  run %{brew install #{ruby_build_deps} #{package_list}}
  run %{brew install grep --with-default-names}
  run %{brew install vim --override-system-vi --with-lua --with-luajit}
  puts
  puts

  # TODO: install casks here
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
  # TODO: update this to use the correct themes and add themes to repo
  run %{ /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Light' dict" ~/Library/Preferences/com.googlecode.iterm2.plist }
  run %{ /usr/libexec/PlistBuddy -c "Merge 'iTerm2/Solarized Light.itermcolors' :'Custom Color Presets':'Solarized Light'" ~/Library/Preferences/com.googlecode.iterm2.plist }
  run %{ /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Dark' dict" ~/Library/Preferences/com.googlecode.iterm2.plist }
  run %{ /usr/libexec/PlistBuddy -c "Merge 'iTerm2/Solarized Dark.itermcolors' :'Custom Color Presets':'Solarized Dark'" ~/Library/Preferences/com.googlecode.iterm2.plist }

  # If iTerm2 is not installed or has never run, we can't autoinstall the profile since the plist is not there
  if !File.exists?(File.join(ENV['HOME'], '/Library/Preferences/com.googlecode.iterm2.plist'))
    puts "======================================================"
    puts "To make sure your profile is using the solarized theme"
    puts "Please check your settings under:"
    puts "Preferences> Profiles> [your profile]> Colors> Load Preset.."
    puts "======================================================"
    return
  end

  # TODO: remove these options
  # Ask the user which theme he wants to install
  message = "Which theme would you like to apply to your iTerm2 profile?"
  color_scheme = ask message, iTerm_available_themes

  return if color_scheme == 'None'

  color_scheme_file = File.join('iTerm2', "#{color_scheme}.itermcolors")

  # Ask the user on which profile he wants to install the theme
  profiles = iTerm_profile_list
  message = "I've found #{profiles.size} #{profiles.size>1 ? 'profiles': 'profile'} on your iTerm2 configuration, which one would you like to apply the Solarized theme to?"
  profiles << 'All'
  selected = ask message, profiles

  if selected == 'All'
    (profiles.size-1).times { |idx| apply_theme_to_iterm_profile_idx idx, color_scheme_file }
  else
    apply_theme_to_iterm_profile_idx profiles.index(selected), color_scheme_file
  end
end

def iTerm_available_themes
   Dir['iTerm2/*.itermcolors'].map { |value| File.basename(value, '.itermcolors')} << 'None'
end

def iTerm_profile_list
  profiles=Array.new
  begin
    profiles <<  %x{ /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':#{profiles.size}:Name" ~/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null}
  end while $?.exitstatus==0
  profiles.pop
  profiles
end

def ask(message, values)
  puts message
  while true
    values.each_with_index { |val, idx| puts " #{idx+1}. #{val}" }
    selection = STDIN.gets.chomp
    if (Float(selection)==nil rescue true) || selection.to_i < 0 || selection.to_i > values.size+1
      puts "ERROR: Invalid selection.\n\n"
    else
      break
    end
  end
  selection = selection.to_i-1
  values[selection]
end

def install_prezto
  puts
  puts "Installing Prezto (ZSH Enhancements)..."

  # TODO: link just the required files for zsh, or just reference them in the linked zshrc
  run %{ ln -nfs "$HOME/.dotfiles/zsh/prezto" "${ZDOTDIR:-$HOME}/.zprezto" }

  # TODO: make sure all files are referenced
  # The prezto runcoms are only going to be installed if zprezto has never been installed
  install_files(Dir.glob('zsh/prezto/runcoms/z*'), :symlink)

  # TODO: substitute this for the zpreztorc that is stored in the .dotfiles
  puts
  puts "Overriding prezto ~/.zpreztorc with YADR's zpreztorc to enable additional modules..."
  run %{ ln -nfs "$HOME/.yadr/zsh/prezto-override/zpreztorc" "${ZDOTDIR:-$HOME}/.zpreztorc" }

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

def needs_migration_to_vundle?
  File.exists? File.join('vim', 'bundle', 'tpope-vim-pathogen')
end


def list_vim_submodules
  result=`git submodule -q foreach 'echo $name"||"\`git remote -v | awk "END{print \\\\\$2}"\`'`.select{ |line| line =~ /^vim.bundle/ }.map{ |line| line.split('||') }
  Hash[*result.flatten]
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
  puts ""
  puts "   _     _           _         "
  puts "  | |   | |         | |        "
  puts "  | |___| |_____  __| | ____   "
  puts "  |_____  (____ |/ _  |/ ___)  "
  puts "   _____| / ___ ( (_| | |      "
  puts "  (_______\_____|\____|_|      "
  puts ""
  puts "Dotfiles installation is #{action}. Please restart your terminal and vim."
end