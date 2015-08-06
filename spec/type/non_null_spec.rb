require 'graphql'

RSpec.describe GraphQL::GraphQLNonNull do

  it 'Should create instance' do
    expect {
      GraphQL::GraphQLNonNull.new(GraphQL::GraphQLString)
    }.not_to raise_error
  end

  it 'Should not create instance' do
    expect {
      GraphQL::GraphQLNonNull.new(GraphQL::GraphQLNonNull.new(GraphQL::GraphQLString))
    }.to raise_error(GraphQL::GraphQLNonNull::NESTING_ERROR)
  end

  it 'Should convert instance to string' do
    nonNullType = GraphQL::GraphQLNonNull.new(GraphQL::GraphQLString)
    expect(nonNullType.to_s).to eql('String!')
  end

end
