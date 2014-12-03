$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "log_monitor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "log_monitor"
  s.version     = LogMonitor::VERSION
  s.authors     = ["JironBach"]
  s.email       = ["jironbach@gmail.com"]
  s.homepage    = "https://github.com/JironBach/log_monitor"
  s.summary     = "Monitoring log."
  s.description = "Monitoring log."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.0"

  #s.add_development_dependency "sqlite3"
end
