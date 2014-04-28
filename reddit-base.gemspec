# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reddit/base/version'

Gem::Specification.new do |spec|
  spec.name          = "reddit-base"
  spec.version       = Reddit::Base::VERSION
  spec.authors       = ["Daniel O'Brien"]
  spec.email         = ["dan@dobs.org"]
  spec.summary       = %q{A minimal reddit API client for Ruby.}
  spec.description   = %q{A minimal reddit API client for Ruby that
    simplifies concerns such as authentication, rate limiting and extracting
    JSON.}
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.required_ruby_version = '>= 2.0.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_dependency 'faraday_middleware-reddit', '0.3.2'
  spec.add_dependency 'hashie', '~> 2.1'
end
