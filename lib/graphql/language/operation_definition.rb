module GraphQL
  module Language
    OperationDefinition = Struct.new('OperationDefinition', :type, :name, :variable_definitions, :directives, :selection_set) do

      def evaluate(schema, root = nil, variables = {}, document)
        context = { schema: schema, document: document }
        type == 'mutation' ? execute_serially(schema, root, variables) : execute(context, root, variables)
      end


      def execute(context, root, variables)
        puts selection_set.evaluate(context, context[:schema].query_type, root)
      end


      def execute_serially(schema, root, variables)
      end


    end
  end
end
