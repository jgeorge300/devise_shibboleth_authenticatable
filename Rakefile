require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the devise_imapable plugin.'
Rake::TestTask.new(:test) do |t|
  # t.libs << 'lib'
  # t.libs << 'test'
  # t.pattern = 'test/**/*_test.rb'
  # t.verbose = true
end

desc 'Generate documentation for the devise_shibboleth_authenticatable plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'DeviseShibbolethAuthenticatable'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "devise_shibboleth_authenticatable"
    gemspec.summary = "Shibboleth authentication module for Devise"
    gemspec.description = "Shibboleth authentication module for Devise"
    gemspec.email = "joe.george@osumc.edu"
    gemspec.homepage = "http://github.com/jgeorge300/devise_shibboleth_authenticatable"
    gemspec.authors = ["Joe George"]
    gemspec.add_runtime_dependency "devise", "> 1.4.0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
