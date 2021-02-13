DIRECTORY_NAME = File.dirname(__dir__)
MACKUP_FILE_NAME = '.mackup.cfg'
MACKUP_DIRECTORY_NAME = '.mackup'

namespace :install do
  desc 'Install mackup configs'
  task :mackup do
    section 'Installing Mackup configs'

    run %( ln -s #{DIRECTORY_NAME + File::SEPARATOR + MACKUP_FILE_NAME} #{"~" + File::SEPARATOR + MACKUP_FILE_NAME} )
    run %( ln -s #{DIRECTORY_NAME + File::SEPARATOR + MACKUP_DIRECTORY_NAME} #{"~" + File::SEPARATOR + MACKUP_DIRECTORY_NAME} )
  end
end

namespace :update do
  desc 'Update/restore files mackup'
  task :mackup do
    section 'Use mackup to restore tracked configurations'

    if ENV['DRY_RUN']
      system %( mackup restore --dry-run )
    else
      run %( mackup restore )
    end
  end
end

namespace :backup do
  desc 'Backup files using mackup'
  task :mackup do
    section 'Using mackup to backup configurations'

    if ENV['DRY_RUN']
      system %( mackup backup --dry-run )
    else
      run %( mackup backup )
    end
  end
end

namespace :uninstall do
  desc 'Uninstall mackup configs'
  task :mackup do
    section 'Use mackup to uninstall tracked configurations'

    if ENV['DRY_RUN']
      system %( mackup uninstall --dry-run )
    else
      run %( mackup uninstall )
    end
  end
end
