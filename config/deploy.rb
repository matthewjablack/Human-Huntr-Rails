# config valid only for Capistrano 3.1
lock '3.4.0'

set :application, 'human_huntr'
set :repo_url, 'git@github.com/mattBlackDesign/human-huntr-rails.git'

set :deploy_to, '/home/deploy'

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'

  # after 'deploy:published', 'restart' do
   #  invoke 'delayed_job:restart'
  # end


end

