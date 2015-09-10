def thread
  ((ENV['TEST_ENV_NUMBER'].nil? || ENV['TEST_ENV_NUMBER'].empty?) ? 1 : ENV['TEST_ENV_NUMBER']).to_i
end

def get_device_udid
  ENV["UDID"] = JSON.parse(ENV["DEVICES"]).find { |t| t["thread"].eql? thread }["udid"]
end

def setup_driver
  @caps = Appium.load_appium_txt file: File.join(File.dirname(__FILE__), 'appium.txt')
  @caps[:caps][:app] = Dir.pwd + "/NotesList.apk"
  @caps[:caps][:udid] = get_device_udid
  @caps[:appium_lib] = {:sauce_username=>false, :sauce_access_key=>false, :wait=>30}
  @caps[:appium_lib][:server_url] = "http://localhost:4444/wd/hub"
  @driver = Appium::Driver.new(@caps).start_driver
end

def promote_methods
  Appium.promote_appium_methods Object
  Appium.promote_appium_methods RSpec::Core::ExampleGroup
end