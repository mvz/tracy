# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "tracy"
  s.version = "0.0.4"

  s.author = "Matijs van Zuijlen"
  s.email = "matijs@matijs.net"
  s.homepage = "http://www.matijs.net"

  s.platform = Gem::Platform::RUBY
  s.summary = "Fun with tracing"
  s.required_ruby_version = ">= 3.0.0"

  s.metadata["rubygems_mfa_required"] = "true"

  s.files = Dir["lib/**/*.rb",
                "features/**/*.rb",
                "features/**/*.feature",
                "bin/*",
                "README.md",
                "Rakefile",
                "Gemfile"]

  s.require_paths << "lib"
  s.bindir = "bin"
  s.executables << "callsites"

  s.add_development_dependency "aruba", "~> 2.0"
  s.add_development_dependency "cucumber", "~> 9.0"
  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "rubocop", "~> 1.52"
  s.add_development_dependency "rubocop-performance", "~> 1.18"
end
