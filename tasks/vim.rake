namespace :install do
  desc "Install Vundle"
  task :vundle do
    section "Installing Vim's Vundle"

    unless File.exists?(File.join(ENV['HOME'], ".vim/bundle/Vundle.vim"))
      run %( git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim )
      run %( vim +BundleInstall +qall < `tty` > `tty` )
    else
      puts "~> Could not install Vim's Vundle. You might already have it installed."
    end
  end
end

namespace :update do
  desc "Update Vim's plugins"
  task :vim do
    section "Updating Vim's Plugins"

    run %( vim -c "BundleInstall" -c "q" -c "q" )
    run %( cd ~/.vim/bundle/YouCompleteMe && sh install.sh )
  end
end
