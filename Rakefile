require_relative 'helpers'

desc 'Running on the grid!'
task :android, :type do |t, args|
  
  system "mkdir output >> /dev/null 2>&1"
  launch_hub_and_nodes
  
  case args[:type]
  when "parallel_rspec"
    puts args[:type]
    exec "parallel_rspec -n #{ENV["THREADS"]} spec"  
  when "parallel_test"
    puts args[:type]
    # devices = JSON.parse(ENV["DEVICES"])
    # Parallel.map_with_index(devices, in_processes: devices.size) do |device, index|
    exec "parallel_test -n #{ENV["THREADS"]} -e 'rspec spec'"
  end
end