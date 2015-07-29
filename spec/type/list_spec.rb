require 'graphql'

RSpec.describe GraphQL::Type::List do


  before(:example) do
    @object = GraphQL::Type::Object.new do
      name "MyObjectType"
    end
    @string = "abc"
  end


  it "should make GraphQL::Type::List of GraphQL::Type::Object" do
    expect {
      GraphQL::Type::List.new(@object)
    }.not_to raise_error
  end


  it "should not make GraphQL::Type::List of String" do
    expect {
      GraphQL::Type::List.new(@string)
    }.to raise_error(GraphQL::Error::TypeError)
  end


end
