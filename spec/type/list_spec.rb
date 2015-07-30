require 'graphql'

RSpec.describe GraphQL::GraphQLList do

  it 'Should create GraphQLList of String' do
    expect {
      GraphQL::GraphQLList.new(String)
    }.not_to raise_error
  end

  it 'Should have string value "[String]" of GraphQLList of String' do
    listType = GraphQL::GraphQLList.new(String)
    expect(listType.to_s).to eql('[String]')
  end

end
