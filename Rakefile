require_relative 'appium_launcher'

desc 'Running on the grid!'
task :android, :type do |t, args|
  
  system "mkdir output >> /dev/null 2>&1"
  launch_hub_and_nodes
  
  case args[:type]
  when "distributed"
    puts args[:type]
    exec "parallel_rspec -n #{ENV["THREADS"]} spec"  
  when "parallel"
    puts args[:type]
    exec "parallel_test -n #{ENV["THREADS"]} -e 'rspec spec'"
  end
end