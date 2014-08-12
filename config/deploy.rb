# configs

# user = "makevoid"
user = "kristinab"
app_name = "gaia_ghost"


# deploy

require 'mina/bundler'
require 'mina/git'

set :domain,      'gaiaconsult.eu'
set :deploy_to,   "/www/#{app_name}"
set :repository,  "git://github.com/#{user}/#{app_name}"
set :branch,      'master'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['log']

set :user, 'www-data'

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do

end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]
end


task :symlink => :environment do
    queue 'rm -rf content/images'
    queue 'rm -rf content/data'
    queue  "ln -s #{deploy_to}/shared/data   content/data"
    queue  "ln -s #{deploy_to}/shared/images content/images"
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :symlink
    # invoke :'bundle:install'

    to :launch do
      queue 'mkdir -p tmp'
      queue 'touch tmp/restart.txt'
    end
  end
end
