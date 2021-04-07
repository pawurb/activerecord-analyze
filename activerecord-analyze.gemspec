# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord-analyze/version'

Gem::Specification.new do |gem|
  gem.name          = "activerecord-analyze"
  gem.version       = ActiveRecordAnalyze::VERSION
  gem.authors       = ["pawurb"]
  gem.email         = ["p.urbanek89@gmail.com"]
  gem.summary       = %q{ Add EXPLAIN ANALYZE to Active Record query objects }
  gem.description   = %q{ Gem adds an "analyze" method to all Active Record query objects. Compatible with PostgreSQL database. }
  gem.homepage      = "http://github.com/pawurb/activerecord-analyze"
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.require_paths = ["lib"]
  gem.license       = "MIT"
  gem.add_dependency "rails", ">= 5.1.0"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "pg"
  gem.add_development_dependency "rspec"
end
