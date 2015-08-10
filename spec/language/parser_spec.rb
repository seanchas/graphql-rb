require 'awesome_print'
require 'graphql'

RSpec.describe GraphQL::Language do

  def query
    %Q(
      query getUser($id: String!, $date: String!) {
        User(id: $id) {

          feed_insights(date: $date, limit: 5, offset: 10)

        }
      }
    )
  end

  it "Should parse query" do
    begin
      GraphQL::Language.parse(query)
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree
    end
  end

end
