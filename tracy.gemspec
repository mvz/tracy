# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'tracy'
  s.version = '0.0.2'

  s.author = 'Matijs van Zuijlen'
  s.email = 'matijs@matijs.net'
  s.homepage = 'http://www.matijs.net'

  s.platform = Gem::Platform::RUBY
  s.summary = 'Fun with tracing'

  s.files = Dir['lib/**/*.rb',
                'features/**/*.rb',
                'features/**/*.feature',
                'bin/*',
                'README.md',
                'Rakefile',
                'Gemfile']

  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'callsites'

  s.add_development_dependency('aruba', '~> 0.14.0')
  s.add_development_dependency('cucumber', '~> 3.0')
  s.add_development_dependency('rake', '~> 12.0')
end
