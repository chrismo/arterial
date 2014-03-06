# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arterial/version'

Gem::Specification.new do |spec|
  spec.name          = 'arterial'
  spec.version       = ARTERIAL_VERSION
  spec.authors       = ['chrismo']
  spec.email         = ['chrismo@clabs.org']
  spec.summary       = %q{Graphs ActiveRecord associations}
  spec.description   = ''
  spec.homepage      = 'http://github.com/chrismo/arterial'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord'
  spec.add_dependency 'ruby-graphviz'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'sqlite3'
end
