$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "graphql/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "graphql"
  s.version     = GraphQL::VERSION
  s.authors     = ["Eugene Kovalev"]
  s.email       = ["seanchas@gmail.com"]
  s.homepage    = "https://github.com/seanchas/graphql"
  s.summary     = "Summary of GraphQL."
  s.description = "Description of GraphQL."

  s.files       = Dir["{lib}/**/*", "Rakefile"]
  s.test_files  = Dir["spec/**/*"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"

  s.add_dependency "parslet"

end
