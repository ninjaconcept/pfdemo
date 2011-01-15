namespace :sass do
  desc 'Updates stylesheets if necessary from their Sass templates.'
  task :update => :environment do
    begin
      Sass::Plugin.update_stylesheets
    rescue
      puts "Install haml/sass gem with: sudo gem install haml"
    end
  end
end