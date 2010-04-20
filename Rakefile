require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sonar-zimbra-pull-connector"
    gem.summary = %Q{Provides a facility to dump mails from a Zimbra server}
    gem.description = %Q{TODO: longer description of your gem}
    gem.email = "apdavidson@gmail.com"
    gem.homepage = "http://github.com/trampoline/sonar-zimbra-pull-connector"
    gem.authors = ["Al Davidson"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_dependency "mysql", ">=2.8.1"
    gem.bindir "bin"
    gem.executables "sonar-zimbra-pull-connector"
    gem.version "0.0.1"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sonar-zimbra-pull-connector #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
