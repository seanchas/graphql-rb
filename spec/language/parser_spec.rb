require 'awesome_print'
require 'graphql'
require_relative '../schema'

RSpec.describe GraphQL::Language do


  def hero_query
    %Q(
      query getHero($episode: Episode!, $heroes: [String] = ["1001", "1002"]) {
        hero(episode: JEDI) {
          id
          name
          friends {
            name

            ... humanFields

            ... on Droid {
              name
              primary_function
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

    expectation = {
      data: {
        hero: {
          id:       "1000",
          name:     "Like Skywalker",
          friends:  [
            {
              name:         "Han Solo",
              home_planet:  nil
            }, {
              name:         "Lea Organa",
              home_planet:  "Alderaan"
            }, {
              name:               "C-3PO",
              primary_function:   "Protocol"
            }, {
              name:               "R2-D2",
              primary_function:   "Astromech"
            }
          ],
          home_planet: "Tatooine"
        }
      }
    }

    result = GraphQL::graphql(StarWars::Schema, hero_query, nil, { episode: 'JEDI', heroes: ['1001'] })
    expect(result).to eql(expectation)
  end

end
