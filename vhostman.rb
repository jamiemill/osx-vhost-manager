#!/usr/bin/env ruby

HOSTS = "/etc/hosts"
VHOSTSDIR = "/etc/apache2/extra/vhosts/" # needs trailing slash

def usage
  puts "\tUSAGE: sudo vhostman add [name] [webroot path]"
end

def check_args
  if ARGV.count < 3
    usage
    exit
  elsif ARGV[0] != 'add'
    usage
    exit
  else
    @name = ARGV[1]
    @domain = @name + '.local'
    @vhost_path = VHOSTSDIR + @domain + '.conf'
    @path = File.expand_path ARGV[2].chomp('/')
  end
end

def check_permission
  if !File.exists? VHOSTSDIR
    puts "\tERROR: VHOSTDIR #{VHOSTSDIR} not found. Please create it."
    exit
  end
  if !File.writable? VHOSTSDIR
    puts "\tERROR: VHOSTDIR #{VHOSTSDIR} not writable. Re-run with 'sudo'."
    exit
  end
  if !File.exists? HOSTS
    puts "\tERROR: HOSTS #{HOSTS} not found."
    exit
  end
  if !File.writable? HOSTS
    puts "\tERROR: HOSTS #{HOSTS} not writable. Re-run with 'sudo'."
    exit
  end
end

def check_path
  if !File.exists? @path
    puts "\tERROR: Specified webroot dir '#{@path}' does not exist."
    exit
  end
end

def check_name
  if File.exists? @vhost_path
    puts "\tERROR: Name '#{@name}' already used."
    exit
  end
end

def make_vhost
  puts "\tMaking vhost file in #{@vhost_path}..."
  File.open(@vhost_path, 'a') do |f|
    f.puts "<Directory \"#{@path}\">"
    f.puts "  Options Indexes FollowSymLinks MultiViews"
    f.puts "  AllowOverride All"
    f.puts "  Order allow,deny"
    f.puts "  Allow from all"
    f.puts "</Directory>"
    f.puts "<VirtualHost *:80>"
    f.puts "  DocumentRoot \"#{@path}\""
    f.puts "  ServerName #{@domain}"
    f.puts "</VirtualHost>"
  end
end

def add_to_hosts
  puts "\tAdding #{@name} to #{HOSTS}..."
  File.open(HOSTS, 'a') do |f|
    f.puts "127.0.0.1 #{@domain}"
  end
end

def restart_apache
  puts "\tRestarting apache..."
  if !`apachectl restart`
    puts "\tERROR: Error restarting apache."
  end
end

def show_complete
  puts "\tOK! Site should be visible at http://#{@domain}"
end

# ----

check_args
check_permission
check_path
check_name
add_to_hosts
make_vhost
restart_apache
show_complete