set :stages, %w(staging production)
set :default_stage, "staging"

require 'capistrano/ext/multistage'
require "bundler/capistrano"

load File.join(File.dirname(__FILE__), 'deploy/config.rb')

namespace :deploy do  
  
  before  "deploy:migrate", "deploy:create_database_yml"
  after   "deploy:update_code", "deploy:migrate"
  before  "symlink", 'web:disable'
  after   "symlink", 'asset:build_package_files'
  after   "restart", 'web:enable'
  after   "deploy", "deploy:cleanup"
  
  namespace :web do
    desc <<-DESC
      Present a maintenance page to visitors. Disables your application's web \
      interface by writing a "maintenance.html" file to each web server. The \
      servers must be configured to detect the presence of this file, and if \
      it is present, always display it instead of performing the request.
    DESC
    task :disable, :roles => :web, :except => { :no_release => true } do
     invoke_command "cp #{current_path}/config/templates/* #{shared_path}/system/"
    end
    
    task :enable, :roles => :web, :except => { :no_release => true } do
      run "rm #{shared_path}/system/maintenance*.html"
    end
  end 
  
  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  desc "Create the database yaml file"
  task :create_database_yml do
    db_config = <<-EOF
    #{stage}:    
      adapter: mysql
      encoding: utf8
      username: #{application}
      password: #{database_password}
      database: #{application}_#{stage}
      host: localhost
    migration:    
      adapter: mysql
      encoding: utf8
      username: deployment
      password: #{deployment_database_password}
      database: #{application}_#{stage}
      host: localhost
    EOF
    
    put db_config, "#{release_path}/config/database.yml"
  end
  
  # this is the db:migrate task from capistrano 2.5.8 with a correct rake command
  desc <<-DESC
    Run the migrate rake task. By default, it runs this in most recently \
    deployed version of the app. However, you can specify a different release \
    via the migrate_target variable, which must be one of :latest (for the \
    default behavior), or :current (for the release indicated by the \
    `current' symlink). Strings will work for those values instead of symbols, \
    too. You can also specify additional environment variables to pass to rake \
    via the migrate_env variable. Finally, you can specify the full path to the \
    rake executable by setting the rake variable. The defaults are:

      set :rake,           "rake"
      set :rails_env,      "production"
      set :migrate_env,    ""
      set :migrate_target, :latest
  DESC
  task :migrate, :roles => :db, :only => { :primary => true } do
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")
    migrate_env = fetch(:migrate_env, "")
    migrate_target = fetch(:migrate_target, :latest)

    directory = case migrate_target.to_sym
      when :current then current_path
      when :latest  then current_release
      else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
      end
    run "cd #{directory}; #{rake} RAILS_ENV=#{migrate_env} db:migrate"
  end
  
end

namespace :db do  
  
  desc 'Dumps the production database to db/production_data.sql on the remote server'
  task :remote_db_dump, :roles => :db, :only => { :primary => true } do
    run "cd #{deploy_to}/#{current_path} && " +
      "rake RAILS_ENV=#{rails_env} db:database_dump --trace" 
  end

  desc 'Downloads db/production_data.sql from the remote production environment to your local machine'
  task :remote_db_download, :roles => :db, :only => { :primary => true } do  
    execute_on_servers(options) do |servers|
      self.sessions[servers.first].sftp.connect do |tsftp|
        tsftp.download!("#{deploy_to}/#{current_path}/db/production_data.sql", "db/production_data.sql")
      end
    end
  end

  desc 'Cleans up data dump file'
  task :remote_db_cleanup, :roles => :db, :only => { :primary => true } do
    execute_on_servers(options) do |servers|
      self.sessions[servers.first].sftp.connect do |tsftp|
        tsftp.remove! "#{deploy_to}/#{current_path}/db/production_data.sql" 
      end
    end
  end 

  desc 'Dumps, downloads and then cleans up the production data dump'
  task :remote_db_runner do
    remote_db_dump
    remote_db_download
    remote_db_cleanup
  end
end

namespace :asset do
  
  namespace :sass do
    before 'asset:build_package_files', 'asset:sass:update'
    desc "build css files from sass"
    task :create, :roles => :web do
      run "cd #{current_path}; rake RAILS_ENV=#{rails_env} sass:update"
    end
  end
  
  desc "build asset packager's merged javascript and stylesheet files"
  task :build_package_files, :roles => :web do
    run "cd #{current_path}; rake RAILS_ENV=#{rails_env} asset:packager:build_all"
  end
  
  after "deploy:symlink", "asset:link_cache_path"
  desc "symlink cache path"
  task :link_cache_path, :roles => :web do
    invoke_command "ln -nfs #{shared_path}/cache #{release_path}/public/cache"
  end
  
  after "deploy:symlink", "asset:link_assets_path"
  desc "symlink assets path"
  task :link_assets_path, :roles => :web do
    invoke_command "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
  end
  
  after "deploy:setup", "asset:create_asset_paths"
  task :create_asset_paths, :roles => :web do
    invoke_command "#{try_sudo} mkdir -p #{shared_path}/assets"
    invoke_command "#{try_sudo} chmod g+w #{shared_path}/assets"
    
    invoke_command "#{try_sudo} mkdir -p #{shared_path}/cache"
    invoke_command "#{try_sudo} chmod g+w #{shared_path}/cache"
  end
  
end


namespace :script do 
  desc "show script/about"
  task :about do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} script/about"
  end
end

namespace :gems do
  desc "show all installed gems"
  task :list do
    run "gem list"
  end
  
  # desc "install all required gems"
  # task :install do
  #   run "cd #{current_path}; rake RAILS_ENV=#{rails_env} #{migrate_env} db:migrate"
  # end
end


namespace :nc do
  namespace :shop do
    
    namespace :categories do
      desc "create default categories"
      task :create_defaults do
        run "cd #{current_path}; rake RAILS_ENV=#{rails_env} nc:shop:categories:create_defaults"
      end
    end
    
    namespace :catalog do
      desc "import catalog. ATTENTION: this will drop all items"
      task :import do
        run "cd #{current_path}; rake RAILS_ENV=#{rails_env} nc:shop:catalog:import"
      end
    end
  end
end


Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end


begin
  require 'hoptoad_notifier/capistrano' 
rescue LoadError
  puts "*****"
  puts "***** HoptoadNotifier not available."
  puts "***** You can't use the deployment notification unless you install 'hoptoad_notifier'!"
  puts "*****"
end
