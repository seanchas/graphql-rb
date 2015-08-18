$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'graphql/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'graphql-rb'
  s.version     = GraphQL::VERSION
  s.authors     = ['Eugene Kovalev']
  s.email       = ['seanchas@gmail.com']
  s.homepage    = 'https://github.com/seanchas/graphql-rb'
  s.summary     = 'Summary of GraphQL.'
  s.description = 'Description of GraphQL.'
  s.license     = 'MIT'

  s.files       = Dir['{lib}/**/*', 'Rakefile']
  s.test_files  = Dir['spec/**/*']

  s.required_ruby_version = '~> 2.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'awesome_print'

  s.add_dependency 'parslet'
  s.add_dependency 'celluloid'
end
