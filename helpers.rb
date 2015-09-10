require 'parallel'
require 'json'

def get_android_devices
  ENV["DEVICES"] = JSON.generate((`adb devices`).lines.select { |line| line.match(/\tdevice$/) }.map.each_with_index { |line, index| { udid: line.split("\t")[0], thread: index + 1 } })
end

def appium_server_start(**options)     
  command = 'appium'
  command << " --nodeconfig #{options[:config]}" if options.key?(:config)
  command << " -p #{options[:port]}" if options.key?(:port)
  command << " -bp #{options[:bp]}" if options.key?(:bp)
  command << " --udid #{options[:udid]}" if options.key?(:udid)
  command << " --log #{Dir.pwd}/output/#{options[:log]}" if options.key?(:log)
  command << " --tmp /tmp/#{options[:tmp]}" if options.key?(:tmp) 
  Dir.chdir('.') {
    pid = spawn(command + " &", :out=>"/dev/null")
    puts 'Waiting for Appium to start up...'
    sleep 10
    if pid.nil?
      puts 'Appium server did not start :('
    end
  }
end

#assumptions
# android only
# only one hub running on port 4444

def generate_node_config(file_name, udid, appium_port)
  system "mkdir node_configs >> /dev/null 2>&1"
  f = File.new(Dir.pwd + "/node_configs/#{file_name}", "w")
  f.write( JSON.generate({ capabilities: [{ browserName: udid, maxInstances: 1, platform: "android" }],
  configuration: { cleanUpCycle: 2000, timeout: 180000, registerCycle: 5000, proxy: "org.openqa.grid.selenium.proxy.DefaultRemoteProxy", url: "http://127.0.0.1:#{appium_port}/wd/hub",
  host: "127.0.0.1", port: appium_port, maxSession: 1, register: true, hubPort: 4444, hubHost: "localhost" } } ) )
  f.close
end

def launch_hub_and_nodes
  #kill any active hub or nodes...
  `ps -ef | grep "selenium" | awk '{print $2}' | xargs kill >> /dev/null 2>&1`
  `ps -ef | grep "appium" | awk '{print $2}' | xargs kill >> /dev/null 2>&1`
  spawn("java -jar selenium-server-standalone-2.47.1.jar -role hub -log #{Dir.pwd}/output/hub.log &", :out=>"/dev/null")
  devices = JSON.parse(get_android_devices)
  ENV["THREADS"] = devices.size.to_s
  Parallel.map_with_index(devices, in_processes: devices.size) do |device, index|
    puts device
    port = 4000 + index
    bp = 2250 + index
    config_name = "#{device["udid"]}.json"
    generate_node_config config_name, device["udid"], port
    node_config = Dir.pwd + "#{config_name}"
    appium_server_start config: node_config, port: port, bp: bp, udid: device["udid"], log: "appium-#{device["udid"]}.log", tmp: device["udid"]
  end
end