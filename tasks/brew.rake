BREW_TAPS_FILE = File.expand_path('../../brew/taps.txt', __FILE__)
BREW_PACKAGES_FILE = File.expand_path('../../brew/packages.txt', __FILE__)
BREW_CASK_PACKAGES_FILE = File.expand_path('../../brew/cask_packages.txt', __FILE__)

namespace :install do
  desc "Install Homebrew"
  task :homebrew do
    section "Installing Homebrew"

    run %( ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" )

    puts "~> Installing brew taps"
    brew_taps.each do |tap|
      run %( brew tap #{tap} )
    end
  end

  desc "Install Brew Packages"
  task :brew_packages do
    section "Installing Brew Packages"

    brew_packages.each do |package|
      run %( brew install #{package} )
    end
  end

  desc "Install Brew Cask Packages"
  task :brew_cask_packages do
    section "Installing Brew Cask Packages"

    brew_cask_packages.each do |package|
      run %( brew cask install --appdir=/Applications --force #{package} )
    end

    run %( brew cask alfred link )
  end
end

namespace :uninstall do
  desc "Uninstall Brew Packages"
  task :brew_packages do
    section "Uninstalling Brew Packages"

    run %( brew rm #{brew_packages.join(" ")} )
  end

  desc "Uninstall Brew Cask Packages"
  task :brew_cask_packages do
    section "Uninstalling Brew Cask Packages"

    run %( brew cask uninstall #{brew_cask_packages.join(" ")} )
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

namespace :backup do
  desc 'Backup Brew Packages'
  task :brew_packages do
    run %( brew list > #{BREW_PACKAGES_FILE} )
  end

  desc 'Backup Brew Cask Packages'
  task :brew_cask_packages do
    run %( brew cask list > #{BREW_CASK_PACKAGES_FILE} )
  end

  desc 'Backup Brew Taps'
  task :brew_taps do
    run %( brew tap > #{BREW_TAPS_FILE} )
  end
end

def brew_taps
  File.readlines(BREW_TAPS_FILE).map(&:strip)
end

def brew_packages
  File.readlines(BREW_PACKAGES_FILE).map(&:strip)
end

def brew_cask_packages
  File.readlines(BREW_CASK_PACKAGES_FILE).map(&:strip)
end
