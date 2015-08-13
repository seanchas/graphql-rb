module GraphQL
  module Language
    Document = Struct.new('Document', :definitions) do

      def execute(schema, root = nil, variables = {}, operation_name = nil)
        raise GraphQLError, "Operation should be defined" if operations.size == 0
        raise GraphQLError, "Operation name should be defined" if operations.size > 1 && operation_name.nil?
        data = operations.first.evaluate(schema, root, variables, self)

        materialize(data)

        { data: data }
      end

      def materialize(data)
        case data
        when Hash
          data.each do |key, value|
            value = value.value if value.is_a?(Celluloid::Future)
            data[key] = value
            materialize(value)
          end
        when Array
          data.each_with_index do |value, index|
            value = value.value if value.is_a?(Celluloid::Future)
            data[index] = value
            materialize(value)
          end
        end
      end

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
