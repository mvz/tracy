# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "tracy"
  spec.version = "0.0.4"
  spec.authors = ["Matijs van Zuijlen"]
  spec.email = ["matijs@matijs.net"]

  spec.platform = Gem::Platform::RUBY
  spec.summary = "Fun with tracing"
  spec.homepage = "http://www.matijs.net"

  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["lib/**/*.rb",
                   "features/**/*.rb",
                   "features/**/*.feature",
                   "bin/*",
                   "README.md",
                   "Rakefile",
                   "Gemfile"]

  spec.require_paths << "lib"
  spec.bindir = "bin"
  spec.executables << "callsites"

  spec.add_development_dependency "aruba", "~> 2.3"
  spec.add_development_dependency "cucumber", "~> 10.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.52"
  spec.add_development_dependency "rubocop-performance", "~> 1.18"
end
