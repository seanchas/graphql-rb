module GraphQL
  module Language

    Operation = Struct.new("Operation", :type, :name, :variables, :directives, :selection_set) do

      def execute(schema)
        case type
        when :query
          selection_set.execute
        when :mutation
          raise GraphQL::GraphQLError, "Schema is not configured for mutations." unless @schema.mutation_type
          selection_set.execute_serially
        else
          raise GraphQLError, "Can only execute queries and mutations."
        end
      end

    end

  end
end
