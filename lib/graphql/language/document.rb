module GraphQL
  module Language
    Document = Struct.new('Document', :definitions) do

      def operation_definitions
        @operation_definitions ||= definitions.reduce({}) do |memo, definition|
          memo[definition.name] = definition if definition.is_a?(OperationDefinition)
          memo
        end
      end

      def fragment_definitions
        @fragment_definitions ||= definitions.reduce({}) do |memo, definition|
          memo[definition.name] = definition if definition.is_a?(FragmentDefinition)
          memo
        end
      end

    end
  end
end
