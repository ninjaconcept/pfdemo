namespace :nc do
  namespace :db do
    namespace :mysql do
    
      desc "create database for application"
      task :create, :roles => :db do
        set :root_password, Capistrano::CLI.password_prompt("MySQL root password: ")
        run "mysql -uroot -p#{root_password} -e \"CREATE DATABASE #{application}_#{stage};\""
      end
    
      desc "create mysql user for application"
      task :create_application_user, :roles => :db do
        unless database_password == ''
          set :root_password, Capistrano::CLI.password_prompt("MySQL root password: ")
          commands = ["mysql -uroot -p#{root_password} -e \"CREATE USER '#{application}'@'localhost' IDENTIFIED BY '#{database_password}';\""]
        
          run commands.join('; ')
        else
          puts "\nENTER PASSWORD FOR MySQL USER #{application}\n\n"
        end
      end
    
      desc "grant application user"
      task :grant_application_user, :roles => :db do
        unless deployment_database_password == ''
          set :root_password, Capistrano::CLI.password_prompt("MySQL root password: ")
          commands = ["mysql -uroot -p#{root_password} -e \"GRANT SELECT, INSERT, UPDATE, DELETE ON #{application}_#{stage} . * TO '#{application}'@'localhost';\""]
        
          run commands.join('; ')
        else
          puts "\nENTER PASSWORD FOR MySQL USER #{application}\n\n"
        end
      end
    
      desc "create deployment user"
      task :create_deployment_user, :roles => :db do
        unless deployment_database_password == ''
          set :root_password, Capistrano::CLI.password_prompt("MySQL root password: ")
          commands =  ["mysql -uroot -p#{root_password} -e \"CREATE USER 'deployment'@'localhost' IDENTIFIED BY '#{deployment_database_password}';\""]
          commands << "mysql -uroot -p#{root_password} -e \"GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, DROP, CREATE, INDEX, LOCK TABLES ON #{application}_#{stage} . * TO 'deployment'@'localhost' WITH GRANT OPTION ;\"";
        
          run commands.join('; ')
        else
          puts "\nENTER PASSWORD FOR MySQL USER deployment\n\n"
        end
      end
    
      desc "grant deployment user"
      task :grant_deployment_user, :roles => :db do
        unless deployment_database_password == ''
          set :root_password, Capistrano::CLI.password_prompt("MySQL root password: ")
          commands = ["mysql -uroot -p#{root_password} -e \"GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, DROP, CREATE, INDEX, LOCK TABLES ON #{application}_#{stage} . * TO 'deployment'@'localhost' WITH GRANT OPTION ;\""]
        
          run commands.join('; ')
        else
          puts "\nENTER PASSWORD FOR MySQL USER deployment\n\n"
        end
      end
    
      desc "create mysql for deployment and application"
      task :create_database_users, :roles => :db do end
      after :create_database_users, :create_deployment_user
      after :create_database_users, :create_application_user
    
      desc "show mysql user"
      task :show_users, :roles => :db do
        set :root_password, Capistrano::CLI.password_prompt("MySQL root password: ")
        run "mysql -uroot -p#{root_password} -e \"select host, user from mysql.user\\G;\""
      end
    
      desc "show grants; specify user with USER"
      task :show_grants, :roles => :db do
        set :root_password, Capistrano::CLI.password_prompt("MySQL root password: ")
        unless ENV['USER']
          user = "CURRENT_USER"
        else
          user = "'#{ENV['USER']}'@localhost"
        end
        run "mysql -uroot -p#{root_password} -e \"show grants for #{user};\""
      end
    
    end
  end
end