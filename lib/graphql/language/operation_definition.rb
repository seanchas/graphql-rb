module GraphQL
  module Language
    OperationDefinition = Struct.new('OperationDefinition', :type, :name, :variable_definitions, :directives, :selection_set) do

      def evaluate(context)
        type == 'mutation' ? execute_serially(context) : execute(context)
      end

      def execute(context)
        selection_set.evaluate(context, context[:schema].query_type, context[:root])
      end

      def execute_serially(context)
        raise "Not implemented. Yet."
      end

      def prepare_variables!(context)
        variable_definitions.each do |variable_definition|
          context[:params][variable_definition.variable.name.to_sym] = variable_definition.value(context)
        end
      end

    end
  end
end
