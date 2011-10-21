# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "taskrabbit/version"

Gem::Specification.new do |s|
  s.name        = "taskrabbit"
  s.version     = Taskrabbit::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jean-Richard Lai"]
  s.email       = ["jrichardlai@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Client for the TaskRabbit API}
  s.description = %q{Client for the TaskRabbit API}

  s.add_development_dependency "rspec"

  s.rubyforge_project = "taskrabbit"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
