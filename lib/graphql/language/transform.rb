require 'parslet'

module GraphQL
  module Language

    Document            = Struct.new("Document", :operations, :fragments) do
      def initialize(definitions)
        self.operations = []
        self.fragments  = []

        definitions.each do |definition|
          case definition
          when SelectionSet
            operations << Operation.new('query', '', [], [], definition)
          when Operation
            operations << definition
          when FragmentDefinition
            fragments << definition
          end
        end
      end
    end

    FragmentDefinition  = Struct.new("FragmentDefinition")
    Field               = Struct.new("Field", :alias, :name, :arguments, :directives, :selection_set) do

      def key
        @key ||= self.alias.nil? || self.alias.empty? ? name : self.alias
      end

    end

    class Transform < Parslet::Transform

      # Document
      #
      rule(
        document_definitions: sequence(:a)
      ) {
        Document.new(a)
      }

      # Selection Set
      #
      rule(
        selections: sequence(:a)
      ) { SelectionSet.new(a) }

      # Operation Definition
      #
      rule(
        type:                    simple(:a),
        name:                    simple(:b),
        variable_definitions:   subtree(:c),
        directives:             subtree(:d),
        selection_set:          subtree(:e)
      ) { Operation.new(a.to_sym, b, c || [], d || [], e || []) }

      # Field
      #
      rule(
        alias:           simple(:a),
        name:            simple(:b),
        arguments:      subtree(:c),
        directives:     subtree(:d),
        selection_set:  subtree(:e)
      ) { Field.new(a.to_s, b, c || [], d || [], e || []) }

      # Name
      #
      rule(name: simple(:a)) { a.to_s }

      # Float Value
      #
      rule(float_value: simple(:a)) { a.to_f }

      # Int Value
      #
      rule(int_value: simple(:a)) { a.to_i }

      # String Value
      #
      rule(string_value: { value: simple(:a) }) { a.to_s }

    end

  end
end
