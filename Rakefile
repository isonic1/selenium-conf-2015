require_relative 'appium_launcher'

desc 'Running on the grid!'
task :android, :type do |t, args|
  
  types = ['dist', 'parallel']
  unless types.include? args[:type]
    puts "Invalid run type!\nChoose: #{types}"
    abort
  end
  
  system "mkdir output >> /dev/null 2>&1"
  launch_hub_and_nodes
  
  case args[:type]
  when "dist"
    puts args[:type]
    exec "parallel_rspec -n #{ENV["THREADS"]} spec"  
  when "parallel"
    puts args[:type]
    exec "parallel_test -n #{ENV["THREADS"]} -e 'rspec spec'"
  end
end