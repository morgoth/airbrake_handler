# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hoptoad_handler"

Gem::Specification.new do |s|
  s.name        = "hoptoad_handler"
  s.version     = HoptoadHandler::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Adam Jacob", "Wojciech Wnętrzak"]
  s.email       = ["w.wnetrzak@gmail.com"]
  s.homepage    = "https://github.com/morgoth/hoptoad_handler"
  s.summary     = %q{Chef handler for sending exceptions to Hoptoad}
  s.description = %q{Chef handler for sending exceptions to Hoptoad}

  s.rubyforge_project = "hoptoad_handler"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("chef", "~> 0.9.0")
  s.add_dependency("toadhopper")

  s.add_development_dependency("test-unit", "~> 2.2.0")
  s.add_development_dependency("mocha")
end
