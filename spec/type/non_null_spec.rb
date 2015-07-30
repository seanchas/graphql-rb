require 'graphql'

RSpec.describe GraphQL::GraphQLNonNull do

  it 'Should create instance' do
    expect {
      GraphQL::GraphQLNonNull.new(String)
    }.not_to raise_error
  end

  it 'Should not create instance' do
    expect {
      GraphQL::GraphQLNonNull.new(GraphQL::GraphQLNonNull.new(String))
    }.to raise_error(GraphQL::GraphQLNonNull::NESTING_ERROR)
  end

  it 'Should convert instance to string' do
    nonNullType = GraphQL::GraphQLNonNull.new(String)
    expect(nonNullType.to_s).to eql('String!')
  end

end
