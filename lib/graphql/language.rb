require_relative 'language/parser'
require_relative 'language/transform'
require_relative 'language/operation'
require_relative 'language/selection_set'

module GraphQL
  module Language

    def self.parse(query)
      transform.apply(parser.parse(query))
    end

  private

    def self.parser
      @parser ||= GraphQL::Language::Parser.new
    end

    def self.transform
      @transform ||= GraphQL::Language::Transform.new
    end

  end
end
