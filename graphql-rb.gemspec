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

  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency 'rspec', '~> 0'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0'
  s.add_development_dependency 'awesome_print', '~> 0'

  s.add_dependency 'parslet', '~> 0'
  s.add_dependency 'celluloid', '~> 0'
end
