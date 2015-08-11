module GraphQL
  module Language
    VariableDefinition = Struct.new('VariableDefinition', :variable, :type, :default_value)
  end
end
