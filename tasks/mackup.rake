ACTIVE_CONFIG_FILE = File.expand_path('~/.mackup.cfg')
BACKUP_CONFIG_FILE = File.expand_path('~/.mackup-backup.cfg')
LOCAL_CONFIG_FILE = File.expand_path('~/.mackup-local.cfg')
DROPBOX_CONFIG_FILE = File.expand_path('~/.mackup-dropbox.cfg')

namespace :update do
  desc "Update using the local mackup config"
  task :mackup_local do
    section "Using mackup to restore tracked configurations from dotfiles repo"

    run %( cp #{ACTIVE_CONFIG_FILE} #{BACKUP_CONFIG_FILE} )
    run %( cp #{LOCAL_CONFIG_FILE} #{ACTIVE_CONFIG_FILE} )
    run %( mackup restore )
    run %( cp #{BACKUP_CONFIG_FILE} #{ACTIVE_CONFIG_FILE} )
  end

  desc "Update using the Dropbox mackup config"
  task :mackup_dropbox do
    section "Using mackup to restore non-tracked configurations from dropbox"

    run %( cp #{ACTIVE_CONFIG_FILE} #{BACKUP_CONFIG_FILE} )
    run %( cp #{DROPBOX_CONFIG_FILE} #{ACTIVE_CONFIG_FILE} )
    run %( mackup dropbox )
    run %( cp #{BACKUP_CONFIG_FILE} #{ACTIVE_CONFIG_FILE} )
  end
end

namespace :backup do
  desc "Backup using the local mackup config"
  task :mackup_local do
    section "Using mackup to backup tracked configurations to dotfiles repo"

    run %( cp #{ACTIVE_CONFIG_FILE} #{BACKUP_CONFIG_FILE} )
    run %( cp #{LOCAL_CONFIG_FILE} #{ACTIVE_CONFIG_FILE} )
    run %( mackup backup )
    run %( cp #{BACKUP_CONFIG_FILE} #{ACTIVE_CONFIG_FILE} )
  end

  desc "Backup using the Dropbox mackup config"
  task :mackup_dropbox do
    section "Using mackup to backup non-tracked configurations to dropbox"

    run %( cp #{ACTIVE_CONFIG_FILE} #{BACKUP_CONFIG_FILE} )
    run %( cp #{DROPBOX_CONFIG_FILE} #{ACTIVE_CONFIG_FILE} )
    run %( mackup backup )
    run %( cp #{BACKUP_CONFIG_FILE} #{ACTIVE_CONFIG_FILE} )
  end
end
