require 'awesome_print'
require 'graphql'

RSpec.describe GraphQL::Language do

  def query
    %Q(
      query getViewer {
        Viewer {
          id: uuid
          name
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
