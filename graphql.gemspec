$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "graphql/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "graphql"
  s.version     = GraphQL::VERSION
  s.authors     = ["Eugene Kovalev"]
  s.email       = ["seanchas@gmail.com"]
  s.homepage    = "https://insights.vc"
  s.summary     = "Summary of GraphQL."
  s.description = "Description of GraphQL."

  s.files = Dir["{lib}/**/*", "Rakefile"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "parslet"
  s.add_dependency "rspec"

end
