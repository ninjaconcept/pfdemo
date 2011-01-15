#############################################################
#  Application
#############################################################

set :application,       "pfdemo"
# set :deploy_to,         "/var/www/sites/#{application}"
set :deploy_to,         "/home/pf/rails/#{application}"

#############################################################
#  Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false
set :scm_verbose, false
set :rails_env,   "staging"
set :migrate_env, "migration"

#############################################################
#  Servers
#############################################################

set :user, "pf"
set :domain, "#{staging_host}"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#  Git
#############################################################

set :scm, :git
set :branch, "master"
set :scm_user, 'git'
set :scm_passphrase, ""
set :repository, "git@github.com:ninjaconcept/#{application}.git"
set :deploy_via, :export
#set :deploy_via, :remote_cache
#set :git_enable_submodules, 1