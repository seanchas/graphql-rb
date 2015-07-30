require 'graphql'

RSpec.describe GraphQL::GraphQLNonNull do

  it 'Should create GraphQLNonNull of String' do
    expect {
      GraphQL::GraphQLNonNull.new(String)
    }.not_to raise_error
  end

  it 'Should not create GraphQLNonNull of GraphQLNonNull' do
    expect {
      GraphQL::GraphQLNonNull.new(GraphQL::GraphQLNonNull.new(String))
    }.to raise_error(GraphQL::GraphQLNonNull::NESTING_ERROR)
  end

  it 'Should have string value "String!" of GraphQLNonNull of String' do
    nonNullType = GraphQL::GraphQLNonNull.new(String)
    expect(nonNullType.to_s).to eql('String!')
  end

end
