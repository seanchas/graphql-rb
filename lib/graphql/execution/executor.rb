module GraphQL
  module Execution

    class Executor

      def initialize(schema, document, root, variables, operation)
        @errors     = []
        @schema     = schema
        @root       = root
        @operations = document.operations.reduce({}) { |memo, operation| memo[operation.name] = operation ; memo }
        @fragments  = document.fragments.reduce({}) { |memo, fragment| memo[fragment.name] = fragment ; memo }
        @operation  = @operations.values.first
      end

      def perform!
        type    = operation_root_type
        fields  = collect_fields(@operation.selection_set)
        if @operation.type == 'mutation'
          raise 'Not implemented. Yet.'
        else
          execute_fields(type, fields)
        end
      end

      def collect_fields(selection_set, fields = {})
        selection_set.selections.reduce(fields) do |memo, selection|
          case selection
          when GraphQL::Language::Field
            (memo[selection.alias.empty? ? selection.name : selection.alias] ||= []) << selection
          end
          memo
        end
      end

      def operation_root_type
        case @operation.type
        when 'query'
          @schema.query_type
        when 'mutation'
          @schema.mutation_type.tap { |mutation| raise GraphQL::GraphQLError, "Schema is not configured for mutations." unless mutation }
        else
          raise GraphQL::GraphQLError, "Can only execute queries and mutations."
        end
      end

      def execute_fields(type, fields)
        fields.each.reduce({}) do |memo, pair|
          key, fields = pair
          memo
        end
      end

    end

  end
end
