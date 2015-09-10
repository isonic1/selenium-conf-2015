require_relative '../setup'
require 'bundler'
Bundler.require(:test)
include Faker

get_device_udid

RSpec.configure do |config|
  
  config.color = true
  config.tty = true
  
  config.before :all do
    setup_driver
    promote_methods
    wait_true { find_element(:id, 'android:id/action_bar_title').text.eql? "Notes" }
  end
    
  config.after :each do |e|
    unless e.exception.nil?
      e.attach_file("Hub Log: #{ENV["UDID"]}", File.new(Dir.pwd + "/output/hub.log"))
      e.attach_file("Appium Log: #{ENV["UDID"]}", File.new(Dir.pwd + "/output/appium-#{ENV["UDID"]}.log"))
      @driver.screenshot $allure_output + "#{e.description}.png"
      e.attach_file("Screenshot: #{e.description}", File.new(Dir.pwd + "/#{$allure_output}#{e.description}.png"))
    end
  end
  
  config.after :all do
    @driver.driver_quit
  end
end

AllureRSpec.configure do |config|
  config.include AllureRSpec::Adaptor
  $allure_output = "output/allure/#{thread}/"
  config.output_dir = $allure_output
  config.clean_dir = true
end

ParallelTests.first_process? ? FileUtils.rm_rf(AllureRSpec::Config.output_dir) : sleep(1)