require File.join(File.dirname(__FILE__), 'test_helper')
 
require 'generators/nc_deployment/nc_deployment_generator'

class NcDeploymentGeneratorTest < Rails::Generators::TestCase
 
  destination File.join("rails_root")
  setup :prepare_destination
  tests ::NcDeploymentGenerator
     
  def teardown
    FileUtils.rm_r(File.join("rails_root"))
  end
 
  test "create the standard deployment files" do
    run_generator %w(TestProject)
    
    expected_files.each do |file|
      if file.is_a? Array
        assert_file file[0], file[1]
      else
        assert_file file
      end
    end
  end
 
  private
  
    def expected_files
      [
        'Capfile',
        'config/deploy.rb',
        'config/deploy/production.rb',
        'config/deploy/staging.rb',
        'config/deploy/config.rb.example',
        ['config/environments/migration.rb', /TestProject::Application.configure do/],
        ['config/environments/staging.rb', /TestProject::Application.configure do/]
      ]
    end
 
    def fake_rails_root
      File.join('rails_root')
    end
 
end