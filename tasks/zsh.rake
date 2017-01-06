namespace :install do
  desc "Install zplug"
  task :zplug do
    section "Installing zplug"

    unless File.exists?(File.join(ENV['ZPLUG_HOME'] || ENV['HOME'], ".zplug"))
      run %( curl -sL zplug.sh/installer | zsh )
      run %( chsh -s /bin/zsh )
      run %( sudo chsh -s /bin/zsh )
    else
      puts "~> Could not install zplug. You might already have it installed."
    end
  end
end
