require 'graphql'

RSpec.describe GraphQL::Type::NonNull do


  before(:example) do
    @object = GraphQL::Type::Object.new do
      name "MyObjectType"
    end
    @string = "abc"
  end


  it "should make GraphQL::Type::NonNull of GraphQL::Type::Object" do
    expect {
      GraphQL::Type::NonNull.new(@object)
    }.not_to raise_error
  end


  it "should not make GraphQL::Type::NonNull of String" do
    expect {
      GraphQL::Type::NonNull.new(@string)
    }.to raise_error(GraphQL::Error::TypeError)
  end


  it "should not make GraphQL::Type::NonNull of GraphQL::Type::NonNull" do
    expect {
      nonNullObject = GraphQL::Type::NonNull.new(@object)
      GraphQL::Type::NonNull.new(nonNullObject)
    }.to raise_error(GraphQL::Error::TypeError)
  end


end
