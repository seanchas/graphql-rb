require 'awesome_print'
require 'graphql'
require_relative '../schema'

RSpec.describe GraphQL::Language do


  def hero_query
    %Q(
      query getHero($episode: Human! = "abc"){
        hero(episode: $episode) {
          id
          name
          friends {
            name
            friends {
              name
              friends {
                name
              }
            }
          }

          ... humanFields

          ... on Droid {
            name
            primary_function
          }
        }
      }

      fragment humanFields on Human {
        name
        home_planet
      }
    )
  end


  it "Should parse query" do
    document = GraphQL::Language.parse(hero_query)
    validator = GraphQL::Validator.new(StarWars::Schema, document, { episode: 4 })
    puts validator.validate!
    puts validator.errors
    puts document.execute(StarWars::Schema, { episode: '4' })
  end

end
