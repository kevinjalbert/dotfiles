BREW_TAPS_FILE = File.expand_path('../../brew/taps.txt', __FILE__)
BREW_PACKAGES_FILE = File.expand_path('../../brew/packages.txt', __FILE__)
BREW_CASK_PACKAGES_FILE = File.expand_path('../../brew/cask_packages.txt', __FILE__)

HEAD_ONLY_FORMULAS = %w( universal-ctags )

namespace :install do
  desc "Install Homebrew"
  task :homebrew do
    section "Installing Homebrew"

    run %( /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" )

    puts "~> Installing brew taps"
    brew_taps.each do |tap|
      run %( brew tap #{tap} )
    end

    run %( brew analytics off )
  end

  desc "Install Brew Packages"
  task :brew_packages do
    section "Installing Brew Packages"

    brew_packages.each do |package|
      if HEAD_ONLY_FORMULAS.include?(package)
        run %( brew reinstall --HEAD #{package} )
      else
        run %( brew install #{package} )
      end
    end
  end

  desc "Install Brew Cask Packages"
  task :brew_cask_packages do
    section "Installing Brew Cask Packages"

    brew_cask_packages.each do |package|
      run %( brew install --cask #{package} )
    end
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
  desc 'Backup all of Brew'
  task :brew do
    run %( brew update )
    Rake::Task['backup:brew_packages'].invoke
    Rake::Task['backup:brew_cask_packages'].invoke
    Rake::Task['backup:brew_taps'].invoke
  end

  desc 'Backup Brew Packages'
  task :brew_packages do
    run %( brew leaves > #{BREW_PACKAGES_FILE} )
  end

  desc 'Backup Brew Cask Packages'
  task :brew_cask_packages do
    run %( brew list --cask> #{BREW_CASK_PACKAGES_FILE} )
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
