require 'rake'
require 'pathname'

def section(title, description="")
  seperator_count = (80 - title.length) / 2
  puts ("\n" + "="*seperator_count) + title.upcase + ("="*seperator_count)
  puts "~> Performing as dry run" if ENV['DRY_RUN']
  puts "~> Performing as super user" if ENV['SUDO']
end

def run(cmd)
  puts "~>#{cmd}"
  system cmd unless ENV['DRY_RUN']
end

def sym_link_for_root(file)
  source = Pathname.new("#{ENV["HOME"]}/#{file}")
  target = Pathname.new("/var/root/#{file}")

  puts "\n~> Symlinking #{file}"
  puts "~> Source #{source}"
  puts "~> Target #{target}"

  # Symlink the whole directory if target is root user (keeps in sync with user), otherwise we symlink only what is necessary
  if source.directory?
    puts "~> Symlinking whole directory where possible so that root/user remain in sync with eachother"
  end
  run %( sudo ln -nfs "#{source}" "#{target}" )
end

def sym_link(source_file, target_file)
  source = Pathname.new("#{Pathname.new(File.dirname(__FILE__)).parent}/#{source_file}")
  target = Pathname.new("#{ENV["HOME"]}/#{target_file}")

  puts "\n~> Symlinking #{source_file}"
  puts "~> Source #{source}"
  puts "~> Target #{target}"

  # Make target path if it does not exist and proceed to symlink
  if source.directory?
    target.mkpath unless target.exist? || target.symlink?
    sym_link_directory source, target
  elsif source.file?
    target.parent.mkpath unless target.parent.exist? || target.parent.symlink?
    sym_link_file source, target
  end
end

def sym_link_directory(source, target)
  source.each_child do |child|
    if child.basename.to_s == ".DS_Store"
      next
    end

    if child.directory?
      sym_link_directory child, Pathname.new("#{target}/#{child.basename}")
    elsif child.file?
      sym_link_file child, Pathname.new("#{target}/#{child.basename}")
    end
  end
end

def sym_link_file(source, target)
  if !target.exist?
    target.parent.mkpath unless target.parent.exist? || target.parent.symlink?
    run %( ln -nfs "#{source}" "#{target}" )
  elsif source.realpath != target.realpath
    puts "Overwriting #{target}... leaving original at #{target}.backup..."
    run %( mv "#{target}" "#{target}.backup" )
    run %( ln -nfs "#{source}" "#{target}" )
  end
end
