require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'
 
Spork.prefork do
 
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
# require 'capybara/webkit/matchers'
# Capybara.javascript_driver = :webkit
 
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
 
RSpec.configure do |config|
 matchers_path = File.dirname(__FILE__) + "/matchers"
 matchers_files = Dir.entries(matchers_path).select {|x| /\.rb\z/ =~ x}
 matchers_files.each do |path|
   require File.join(matchers_path, path)
 end
 config.include(CustomModelMatchers)
 
  config.include Capybara::DSL
  config.infer_base_class_for_anonymous_controllers = false
  config.include FactoryGirl::Syntax::Methods
  config.infer_spec_type_from_file_location!
  
  config.order = "random"
  # config.color_enabled = true
  config.tty = true
  config.formatter = :documentation # :progress, :html, :textmate


  # config.include(Capybara::Webkit::RspecMatchers, :type => :feature)
 

end
 
end
 
Spork.each_run do
  
  FactoryGirl.reload

  OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '123545',
      credentials:  {
        expires_at:   Time.now + 10.year,
        token:  SecureRandom.urlsafe_base64
      },
      info: {
         nickname: "test_twitter",
         first_name: "Test",
         last_name: "Twitter",
         country: "UK"
      }
    })

OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '12333dasdasd',
      credentials:  {
        expires_at:   Time.now + 10.year,
        token:  SecureRandom.urlsafe_base64
      },
      info: {
         email: "test@facebook.com",
         nickname: "test_facebook",
         first_name: "Test",
         last_name: "facebook",
         country: "UK"
      }
    })

OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
      provider: 'linkedin',
      uid: 'sdadadqwe',
      credentials:  {
        expires_at:   Time.now + 10.year,
        token:  SecureRandom.urlsafe_base64
      },
      info: {
         email: "test@linkedin.com",
         nickname: "test_linkedin",
         first_name: "Test",
         last_name: "linkedin",
         country: "UK"
      }
    })

OmniAuth.config.mock_auth[:gplus] = OmniAuth::AuthHash.new({
      provider: 'gplus',
      uid: 'qweqwewe',
      credentials:  {
        expires_at:   Time.now + 10.year,
        token:  SecureRandom.urlsafe_base64
      },
      info: {
         email: "test@linkedin.com",
         nickname: "test_linkedin",
         first_name: "Test",
         last_name: "linkedin",
         country: "UK"
      }
    })


end

