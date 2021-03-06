require_relative 'language/document'
require_relative 'language/operation_definition'
require_relative 'language/fragment_definition'
require_relative 'language/fragment_spread'
require_relative 'language/inline_fragment'
require_relative 'language/selection_set'
require_relative 'language/variable_definition'
require_relative 'language/variable'
require_relative 'language/named_type'
require_relative 'language/list_type'
require_relative 'language/non_null_type'
require_relative 'language/name'
require_relative 'language/value'
require_relative 'language/field'
require_relative 'language/argument'
require_relative 'language/directive'

require_relative 'language/parser'
require_relative 'language/transform'


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
