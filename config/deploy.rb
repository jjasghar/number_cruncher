set :application, 'number_cruncher'
set :repo_url, 'git@github.com:jjasghar/number_cruncher.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/var/www/number_cruncher'
set :scm, :git

set :format, :pretty
set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5
#
set :bundle_flags, "--deployment"
set :bundle_bins, fetch(:bundle_bins).push("unicorn")

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      execute "/etc/init.d/nginx restart"
      within current_path do
        execute :unicorn, "-c unicorn.rb -E production -D"
      end
    end
  end

  after "deploy:finished", "deploy:restart"

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
