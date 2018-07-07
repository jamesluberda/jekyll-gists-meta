# frozen_string_literal: true

# lib = File.expand_path("../lib", __FILE__)
lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll/gists/meta/version"

Gem::Specification.new do |spec|
  spec.name          = "jekyll-gists-meta"
  spec.version       = Jekyll::Gists::Meta::VERSION
  spec.authors       = ["James Luberda"]
  spec.email         = ["james.luberda@gmail.com"]

  spec.summary       = "Generates a json data file for Jekyll containing metadata about a user's gists"
  spec.homepage      = "https://github.com/jamesluberda/jekyll-gists-meta"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r!^(test|spec|features)/!) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r!^exe/!) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "jekyll", "~> 3.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.55.0"
end
