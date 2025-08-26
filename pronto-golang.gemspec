# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'pronto/golang/version'
require 'English'

Gem::Specification.new do |s|
  s.name                  = 'pronto-golang'
  s.version               = Pronto::GolangVersion::VERSION
  s.platform              = Gem::Platform::RUBY
  s.author                = 'Tobias Schoknecht'
  s.email                 = 'tobias.schoknecht@viafintech.com'
  s.homepage              = 'https://github.com/viafintech/pronto-golang'
  s.summary               = 'Pronto runner for golang tools'

  s.licenses              = ['MIT']
  s.required_ruby_version = '>= 3.0.0'
  s.rubygems_version      = '2.4'

  s.files                 = Dir['lib/**/*.rb']
  s.test_files            = []
  s.extra_rdoc_files      = ['LICENSE', 'README.md']
  s.require_paths         = ['lib']

  s.add_runtime_dependency('pronto', '>= 0.11.0')
  s.add_development_dependency('rake', '~> 13.0')
  s.add_development_dependency('rspec', '~> 3.12')
  s.add_development_dependency('base64', '~> 0.3.0')
  s.add_development_dependency('ostruct', '~> 0.6.3')
end
