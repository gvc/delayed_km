# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "delayed_kiss/version"

Gem::Specification.new do |s|
  s.name        = "delayed_kiss"
  s.version     = DelayedKiss::VERSION
  s.authors     = ["Dustin DeYoung"]
  s.email       = ["ddeyoung@authorsolutions.com"]
  s.homepage    = ""
  s.summary     = %q{KissMetrics API with Delayed Job}
  s.description = %q{A simple wrapper for the KissMetrics API using Delayed Job}

  s.rubyforge_project = "delayed_kiss"

  s.files         = [".gitignore", ".rspec", ".rvmrc", ".travis.yml", "Gemfile", "README.textile", "Rakefile", "delayed_kiss.gemspec", "lib/delayed_kiss.rb", "lib/delayed_kiss/railtie.rb", "lib/delayed_kiss/version.rb", "lib/generators/delayed_kiss/install/install_generator.rb", "lib/generators/delayed_kiss/install/templates/.DS_Store", "lib/generators/delayed_kiss/install/templates/config/.DS_Store", "lib/generators/delayed_kiss/install/templates/config/delayed_kiss.yml", "spec/delayed_kiss_spec.rb", "spec/spec_helper.rb"]
  s.test_files    = ["spec/delayed_kiss_spec.rb", "spec/spec_helper.rb"]
  s.executables   = []
  s.require_paths = ["lib"]

  s.add_dependency("activesupport")
  s.add_dependency("i18n")
  s.add_dependency("httparty", ">= 0.8.1")
  s.add_dependency("delayed_job", ">= 2.1.4")
end
