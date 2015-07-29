require 'graphql'

RSpec.describe GraphQL::Argument do

  it "Should not make GraphQL::Argument without type" do
    expect {
      GraphQL::Argument.new do
        name "MyArgument"
      end
    }.to raise_error(GraphQL::Error::ValidationError)
  end

  it "Should make argument of GraphQL::String type" do
    expect {
      GraphQL::Argument.new do
        name  "My Argument"
        type  GraphQL::String
      end
    }.not_to raise_error
  end

  it "Should not make argument of String type" do
    expect {
      GraphQL::Argument.new do
        name  "My Argument"
        type  ::String
      end
    }.to raise_error(GraphQL::Error::TypeError)
  end

end
