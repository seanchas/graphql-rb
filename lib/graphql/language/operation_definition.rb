module GraphQL
  module Language
    OperationDefinition = Struct.new('OperationDefinition', :type, :name, :variable_definitions, :directives, :selection_set) do


      def evaluate(context)
        context[:variables] = materialize_variables(context[:schema], context[:params])
        type == 'mutation' ? execute_serially(context) : execute(context)
      end


      def execute(context)
        selection_set.evaluate(context, context[:schema].query_type, context[:root])
      end


      def execute_serially(context)
        raise "Not implemented. Yet."
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
