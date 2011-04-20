# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "to_regexp/version"

Gem::Specification.new do |s|
  s.name        = "to_regexp"
  s.version     = ToRegexp::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Seamus Abshere"]
  s.email       = ["seamus@abshere.net"]
  s.homepage    = ""
  s.summary     = %q{Provides String#to_regexp and Regexp#to_regexp}
  s.description = %q{Provides String#to_regexp and Regexp#to_regexp, for example if you want to make regexps out of a CSV you just imported.}

  s.rubyforge_project = "to_regexp"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency 'ensure-encoding'
end
