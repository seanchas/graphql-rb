module GraphQL
  module Language
    Document = Struct.new('Document', :definitions) do

      def operations
        @operations ||= definitions.select { |definition| definition.is_a?(OperationDefinition) }
      end

      def operation(name)
        operations.find { |operation| operation.name == name }
      end

      def fragments
        @fragments ||= definitions.select { |definition| definition.is_a?(FragmentDefinition) }
      end

      def fragment(name)
        fragments.find { |fragment| fragment.name == name }
      end

    end
  end
end
