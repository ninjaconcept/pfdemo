namespace :nc do
  namespace :deploy do
    desc "prepare deployment environment"
    task :prepare => :environment do
    
      unless (ENV.include?("env") || ENV.include?("project")) && (ENV['env']=='staging' || ENV['env']=='production')
        raise "usage: rake ninja:deploy:prepare env=ENV project=PROJECT # valid environments are [staging] or [production]" 
      end
      environment = ENV['env']
      project = ENV['project']
      
      puts "***** setting up deployment environment for '#{environment}'"
      puts "***** creating directories"
      sh "cap #{environment} deploy:setup"
      
      puts "***** creating database"
      sh "cap #{environment} nc:db:mysql:create"
      
      puts "***** creating a mysql use for the application"
      sh "cap #{environment} nc:db:mysql:create_application_user"
      
      puts "***** granting access for the application user"
      sh "cap #{environment} nc:db:mysql:grant_application_user"
      
      puts "***** granting access for the deployment user"
      sh "cap #{environment} nc:db:mysql:grant_deployment_user"
      
      puts "***** making a cold deploy"
      sh "cap #{environment} deploy:cold"
      
      puts "***** performing a full deploy"
      sh "cap #{environment} deploy"
      
      puts "***** creating a sample apache2 vhost"
      sh "rake nc:deploy:vhost project=#{project} "
      
      puts "***** deployment ready for '#{environment}'"
      
      puts "***** your next steps are"
      puts "***** "
      puts "***** set up a vhost"
      puts "***** link a subdomain"
      puts "***** have fun :)"
    
    end
    
    desc "create sample vhost"
    task :vhost => :environment do
      
      unless ENV.include?("project")
        raise "usage: rake ninja:deploy:vhost project=PROJECTNAME" 
      end
      project = ENV['project']
            

      vhost = <<-EOF
<VirtualHost *:80>
  ServerName #{project}.projects.ninjaconcept.com


  # default is production
  RailsEnv staging

  # remove comment for htaccess
  Include /etc/apache2/sites-include/require-authentication

  # only for production
  # Include /etc/apache2/sites-include/cache-settings

  DocumentRoot /var/www/sites/#{project}/current/public

  # RewriteEngine On

  # RewriteCond %{HTTP_HOST} !^www.#{project}.com$ [NC]
  # RewriteCond %{HTTP_HOST} !^asset[0-3].#{project}.com$ [NC]
  # RewriteRule ^(.*)$ http://www.#{project}.com$1 [R,L]   

  LogLevel  info
  ErrorLog  /var/log/apache2/#{project}-error.log
  CustomLog  /var/log/apache2/#{project}-full.log    combined    env=!dontlog

</VirtualHost>
      EOF
      
      puts ""
      puts "**************************************************"
      puts ""      
      puts "APACHE2 VHOST"
      puts ""
      puts "**************************************************"
      puts ""
      puts ""
      puts vhost
      puts ""
      puts ""
      puts "**************************************************"
      puts ""
      puts ""
      
    end
    
  end
end