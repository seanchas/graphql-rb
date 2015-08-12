module GraphQL
  module Language
    OperationDefinition = Struct.new('OperationDefinition', :type, :name, :variable_definitions, :directives, :selection_set) do

      def evaluate(schema, root = nil, variables = {})
        type == 'mutation' ? execute_serially(schema, root, variables) : execute(schema, root, variables)
      end


      def execute(schema, root, variables)
        grouped_fields = selection_set.fields(schema.query_type)
        grouped_fields.each do |key, fields|
          Field.entry(key, schema.query_type, root, fields, {})
        end
      end


      def execute_serially(schema, root, variables)
      end


    end
  end
end
