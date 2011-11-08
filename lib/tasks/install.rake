$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

task :build do 
  system "gem build archiver.gemspec"
end

task :release => :build do 
  system "gem push archiver-*"
end

task :install => :build do 
  Rake::Task['build'].invoke
  system "gem install archiver-*"
end
