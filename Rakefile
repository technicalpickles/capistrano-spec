require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "capistrano-spec"
    gem.version = '0.6.2'

    gem.summary = %Q{Test your capistrano recipes}
    gem.description = %Q{Helpers and matchers for testing capistrano}
    gem.email = "josh@technicalpickles.com"
    gem.homepage = "http://github.com/technicalpickles/capistrano-spec"
    gem.authors = ["Joshua Nichols", "Karl Matthias", "Peter M Souter", "Jan Graichen"]
    gem.add_development_dependency "rspec", ">= 2.0.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = '--color --format=documentation -I lib -I spec'
  spec.pattern = "spec/**/*_spec.rb"
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rspec_opts = '-I lib -I spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => [:spec]

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "capistrano-spec #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
