# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'Bender'
set :repo_url, 'git@bitbucket.org:alphav/bender.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/app/bender'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'public/pf', 'tmp/pids'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2


namespace :monit do 
  desc "Task description"
  task :stop do
    on roles(:app) do
      sudo 'monit unmonitor rake-bender'
      sudo 'monit stop thin-bender'
      sudo '/app/bender/current/rake_bender.sh stop'
      #sudo '/app/bender/shared/bundle/ruby/2.3.0/bin/thin stop -P /app/bender/current/tmp/pids/thin.3333.pid'
    end
  end

  desc "Task description"
  task :start do
    on roles(:app) do
      sudo 'monit monitor rake-bender'
      sudo 'monit monitor thin-bender'
      sudo 'monit start rake-bender'
      sudo 'monit start thin-bender'
    end    
  end
end

namespace :deploy do
  before :deploy, "monit:stop"
  after :deploy, "monit:start"
end
