module GraphQL
  module Language
    FragmentDefinition = Struct.new('FragmentDefinition', :name, :type_condition, :directives, :selection_set)
  end
end
