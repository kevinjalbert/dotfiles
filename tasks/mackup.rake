DIRECTORY_NAME = File.dirname(__dir__)
MACKUP_FILE_NAME = '.mackup.cfg'
MACKUP_DIRECTORY_NAME = '.mackup'

namespace :install do
  desc 'Install mackup configs'
  task :mackup do
    section 'Installing Mackup configs'

    run %( cp #{DIRECTORY_NAME + File::SEPARATOR + MACKUP_FILE_NAME} #{"~" + File::SEPARATOR + MACKUP_FILE_NAME} )
    run %( cp -R #{DIRECTORY_NAME + File::SEPARATOR + MACKUP_DIRECTORY_NAME} #{"~" + File::SEPARATOR + MACKUP_DIRECTORY_NAME} )
  end
end

namespace :update do
  desc 'Update files mackup'
  task :mackup do
    section 'Use mackup to restore tracked configurations'

    run %( mackup restore )
  end
end

namespace :backup do
  desc 'Backup files using mackup'
  task :mackup_local do
    section 'Using mackup to backup configurations'

    run %( mackup backup )
  end
end

namespace :uninstall do
  desc 'Uninstall mackup configus'
  task :mackup do
    section 'Use mackup to uninstall tracked configurations'

    run %( mackup uninstall )
  end
end
