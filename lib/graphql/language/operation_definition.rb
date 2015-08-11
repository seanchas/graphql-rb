module GraphQL
  module Language
    OperationDefinition = Struct.new('OperationDefinition', :type, :name, :variable_definitions, :directives, :selection_set)
  end
end
