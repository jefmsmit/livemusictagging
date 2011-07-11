# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "livemusictagging/version"

Gem::Specification.new do |s|
  s.name        = "livemusictagging"
  s.version     = LiveMusicTagging::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jeff Smith"]
  s.email       = ["jefmsmit@gmail.com"]
  s.homepage    = ""
  s.summary     = "Tools Useful to live music traders"
  s.description = "A Gem containing utilities for things needed to deal with live music. Converting SHN to WAV, validing MD5, tagging FLAC files, etc."

  s.rubyforge_project = "livemusictagging"

  s.add_development_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
