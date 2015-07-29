require 'parslet'
require 'graphql/query/parser'
require 'graphql/query/transform'

module GraphQL

  module Query

    def self.parse(query)
      transform.apply(parser.parse(query))
    end

  private

    def self.parser
      @parser ||= GraphQL::Query::Parser.new
    end

    def self.transform
      @transform ||= GraphQL::Query::Transform.new
    end

  end

end
