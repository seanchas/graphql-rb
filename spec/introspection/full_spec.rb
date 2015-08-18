require 'graphql'
require_relative '../schema'
require 'awesome_print'

RSpec.describe "Introspection - Full" do

  it "Should allow querying the schema" do
    expect {
      GraphQL::graphql(StarWars::Schema, GraphQL::Introspection::Query, {}, {})
    }.not_to raise_error
  end

end
