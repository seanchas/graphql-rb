require 'graphql'

RSpec.describe GraphQL::GraphQLList do

  it 'Should create' do
    expect {
      GraphQL::GraphQLList.new(String)
    }.not_to raise_error
  end

  it 'Should convert instance to string' do
    listType = GraphQL::GraphQLList.new(String)
    expect(listType.to_s).to eql('[String]')
  end

end
