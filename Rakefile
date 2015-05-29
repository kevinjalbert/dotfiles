=begin
Before running the Rakefile, ensure that the following are installed on your system:
  - Ruby, Vim, Zsh

This Rakefile should not be ran with sudo, it will use sudo where nessecary.

Symlinking root files should be done last to ensure everything is setup first.

To perform tasks in a 'dry run' state append the following to your command:
  DRY_RUN=
=end

Dir.glob('./tasks/**/*').map { |file| load file }

task :default => [:install]

desc "Backup Everything"
task :backup do
  Rake::Task['backup:brew_packages'].invoke
  Rake::Task['backup:brew_cask_packages'].invoke
  Rake::Task['backup:brew_taps'].invoke
end

desc "Install Everything"
task :install do
  Rake::Task['install:homebrew'].invoke
  Rake::Task['install:brew_packages'].invoke
  Rake::Task['install:brew_cask_packages'].invoke
  Rake::Task['install:prezto'].invoke
  Rake::Task['install:rvm'].invoke
  Rake::Task['install:fonts'].invoke
  Rake::Task['install:vundle'].invoke
  Rake::Task['update:vim'].invoke
  Rake::Task['install:symlinks'].invoke
  Rake::Task['install:symlinks_root'].invoke
  Rake::Task['install:osx'].invoke
end

desc "Update Everything"
task :update do
  Rake::Task['update:vim'].invoke
  Rake::Task['update:brew_packages'].invoke
  Rake::Task['update:brew_cask_packages'].invoke
end

desc "Uninstall Everything"
task :uninstall do
  Rake::Task['uninstall:brew_packages'].invoke
  Rake::Task['uninstall:brew_cask_packages'].invoke
end
