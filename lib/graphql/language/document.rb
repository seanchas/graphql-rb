module GraphQL
  module Language
    Document = Struct.new('Document', :definitions) do

      def execute(schema, root = nil, variables = {}, operation_name = nil)
        operations.first.evaluate(schema, root, variables)
      end

      def operations
        @operations ||= definitions.select { |definition| definition.is_a?(OperationDefinition) }
      end

      def fragments
        @fragments ||= definitions.select { |definition| definition.is_a?(FragmentDefinition) }
      end

    end
  end
end
