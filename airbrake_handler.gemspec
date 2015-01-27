# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "airbrake_handler"
  s.version     = "0.5.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Adam Jacob", "Wojciech Wnętrzak"]
  s.email       = ["w.wnetrzak@gmail.com"]
  s.homepage    = "https://github.com/morgoth/airbrake_handler"
  s.summary     = %q{Chef handler for sending exceptions to Airbrake}
  s.description = %q{Chef handler for sending exceptions to Airbrake}
  s.license     = "Apache"

  s.rubyforge_project = "airbrake_handler"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("chef", ">= 0.9.0")
  s.add_dependency("toadhopper", ">= 2.0")

  s.add_development_dependency("mocha", ">= 1.1.0")
end
