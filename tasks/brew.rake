def get_brew_taps
  return %w(
    caskroom/cask
    caskroom/versions
  )
end

def get_brew_packages
  return %w(
    ack
    brew-cask
    cgrep
    coreutils
    ctags
    elasticsearch
    ffmpeg
    fzf
    gcc
    git
    git-extras
    hr
    htop-osx
    hub
    imagemagick
    imagesnap
    jq
    vim
    mackup
    mercurial
    mysql
    node
    openssl
    postgresql
    python
    python3
    qlcolorcode
    qlstephen
    qlmarkdown
    quicklook-json
    qlprettypatch
    quicklook-csv
    betterzipql
    webp-quicklook
    suspicious-package
    reattach-to-user-namespace
    redis
    libyaml
    s3cmd
    siege
    sloccount
    sqlite
    the_silver_searcher
    tmux
    vim
    youtube-dl
    zsh
    z
  )
end

def get_brew_cask_packages
  return %w(
    alfred
    appcleaner
    bartender
    cyberduck
    dash
    diffmerge
    doxie
    dropbox
    enjoyable
    evernote
    eye-fi
    flux
    firefox
    fluid
    gitter
    google-drive
    handbrake
    hipchat
    hyperswitch
    ibettercharge
    iexplorer
    istat-menus
    iterm2
    karabiner
    launchrocket
    logmein-hamachi
    mou
    openemu-experimental
    pg-commander
    postgres
    rescuetime
    seil
    sequel-pro
    shortcat
    skype
    sourcetree
    steam
    sublime-text3
    teamviewer
    the-unarchiver
    trailer
    tuxguitar
    utorrent
    vagrant
    vimediamanager
    virtualbox
    vlc
    whatpulse
  )
end

namespace :install do
  desc "Install Homebrew"
  task :homebrew do
    section "Installing Homebrew"

    run %( ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" )

    get_brew_taps.each do |package|
      run %( brew tap #{package} )
    end
  end

  desc "Install Brew Packages"
  task :brew_packages do
    section "Installing Brew Packages"

    get_brew_packages.each do |package|
      run %( brew install #{package} )
    end
  end

  desc "Install Brew Cask Packages"
  task :brew_cask_packages do
    section "Installing Brew Cask Packages"

    get_brew_cask_packages.each do |package|
      run %( brew cask install --appdir=/Applications --force #{package} )
    end

    run %( brew cask alfred link )
  end
end

namespace :uninstall do
  desc "Uninstall Brew Packages"
  task :brew_packages do
    section "Uninstalling Brew Packages"

    run %( brew rm #{get_brew_packages.join(" ")} )
  end

  desc "Uninstall Brew Cask Packages"
  task :brew_cask_packages do
    section "Uninstalling Brew Cask Packages"

    run %( brew cask uninstall #{get_brew_cask_packages.join(" ")} )
  end
end

namespace :update do
  desc "Update Brew"
  task :brew_packages do
    section "Updating Brew Packages"

    run %( brew update )
    run %( brew upgrade )
  end

  desc "Update Brew Cask"
  task :brew_cask_packages do
    section "Updating Brew Cask Packages"

    puts "~> Uninstalls and Reinstalls Brew Cask Packages"
    Rake::Task['uninstall:brew_cask_packages'].invoke
    Rake::Task['install:brew_cask_packages'].invoke
  end
end
