SSH_USER = 'deploy'
#SSH_HOST = 'static2.blackbeartheory.com'

if ENV['DEPLOY'] == 'PRODUCTION'
  SSH_DIR  = '/var/www/walkdenton'
else
  SSH_DIR  = '/var/www/dev-walkdenton'
end


SSH_HOSTS = [
  'static2.blackbeartheory.com',
  'static1.bbttxu.com'
]

desc "Build the website from source"
task :build do
  puts "## Building website"
  status = system("mimosa build -m")
  puts status ? "OK" : "FAILED"
end

desc "Run the preview server at http://localhost:4567"
task :preview do
  system("mimosa watch -s")
end

desc "Deploy website via rsync"
task :deploy do
  SSH_HOSTS.each do |ssh_host|
    puts "## Deploying website via rsync to #{ssh_host}"
    status = system("rsync -avze 'ssh' --delete public/ #{SSH_USER}@#{ssh_host}:#{SSH_DIR}")
    puts status ? "OK" : "FAILED"
  end
end

desc "Build and deploy website"
task :gen_deploy => [:build, :deploy] do
end
