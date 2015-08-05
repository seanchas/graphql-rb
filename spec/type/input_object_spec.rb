require 'graphql'

RSpec.describe GraphQL::GraphQLInputObjectType do


  def input_type
    @input_type ||= GraphQL::GraphQLInputObjectType.new do
      name 'GeoPoint'

      field 'lat', GraphQL::GraphQLNonNull.new(GraphQL::GraphQLFloat)
      field 'lon', GraphQL::GraphQLNonNull.new(GraphQL::GraphQLFloat)
      field 'alt', GraphQL::GraphQLFloat, default_value: 0
    end
  end


  it "Should create input type" do
    expect { input_type }.not_to raise_error
  end

end
