Gem::Specification.new do |s|
  s.name = 'tracy'
  s.version = '0.0.1'

  s.author = 'Matijs van Zuijlen'
  s.email = 'matijs@matijs.net'
  s.homepage = 'http://www.matijs.net'

  s.platform = Gem::Platform::RUBY
  s.summary = 'Fun with tracing'

  s.files = Dir['{lib}/**/*.rb', 'bin/*', 'README.md', 'Rakefile']

  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'callsites'

  s.add_development_dependency('rake', '~> 10.3')
  s.add_development_dependency('aruba', '~> 0.10.2')
  s.add_development_dependency('cucumber', '~> 2.0')
end
