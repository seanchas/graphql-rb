module GraphQL
  module Language
    Field = Struct.new('Field', :alias, :name, :arguments, :directives, :selection_set)
  end
end
