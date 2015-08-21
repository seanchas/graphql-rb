module GraphQL
  module Language
    OperationDefinition = Struct.new('OperationDefinition', :type, :name, :variable_definitions, :directives, :selection_set) do


      def evaluate(context)
        context[:variables] = materialize_variables(context[:schema], context[:params])
        arguments = [
          type == 'mutation' ? context[:schema].mutation_type : context[:schema].query_type,
          type == 'mutation'
        ]
        execute(context, *arguments)
      end


      def execute(context, type, serially = false)
        selection_set.evaluate(context, type, context[:root], serially: serially)
      end


      def materialize_variables(schema, params)
        variable_definitions.reduce({}) do |memo, variable_definition|
          name = variable_definition.variable.name.to_sym
          memo[name] = variable_definition.materialize(schema, params[name])
          memo
        end
      end


    end
  end
end
