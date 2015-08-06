require 'graphql'
require_relative '../data'

RSpec.describe GraphQL::GraphQLSchema do

  it "Should have query and shouldn't have mutation" do
    expect(StarWars::Schema.query_type).not_to eql(nil)
    expect(StarWars::Schema.mutation_type).to eql(nil)

    puts StarWars::Schema.type_map.keys.inspect
  end

end
