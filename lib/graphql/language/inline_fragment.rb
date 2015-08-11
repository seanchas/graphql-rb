module GraphQL
  module Language
    InlineFragment = Struct.new('InlineFragment', :type_condition, :directives, :selection_set)
  end
end
