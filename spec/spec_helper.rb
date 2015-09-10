require 'bundler'
Bundler.require(:test)
include Faker

def thread
  ((ENV['TEST_ENV_NUMBER'].nil? || ENV['TEST_ENV_NUMBER'].empty?) ? 1 : ENV['TEST_ENV_NUMBER']).to_i
end

ENV["UDID"] = JSON.parse(ENV["DEVICES"]).find { |t| t["thread"].eql? thread }["udid"]

RSpec.configure do |config|
  
  config.color = true
  config.tty = true

  config.before :all do
    caps = Appium.load_appium_txt file: File.join(File.dirname(__FILE__), '../appium.txt')
    caps[:caps][:app] = Dir.pwd + "/NotesList.apk"
    caps[:caps][:udid] = ENV["UDID"]
    caps[:appium_lib] = {:sauce_username=>false, :sauce_access_key=>false, :wait=>30}
    caps[:appium_lib][:server_url] = "http://localhost:4444/wd/hub" #Change this to your hub url if different.
    
    @driver = Appium::Driver.new(caps).start_driver
    Appium.promote_appium_methods Object
    Appium.promote_appium_methods RSpec::Core::ExampleGroup
    
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