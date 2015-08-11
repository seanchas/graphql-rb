require 'awesome_print'
require 'graphql'
require_relative '../schema'

RSpec.describe GraphQL::Language do


  def hero_query
    %Q(
      {
        hero(episode: $episode) {
          id
          name
        }
      }
    )
  end


  it "Should parse query" do
    document = GraphQL::Language.parse(hero_query)
    document.execute(StarWars::Schema)
  end

end
