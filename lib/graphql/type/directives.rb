module GraphQL

  GraphQLIncludeDirective = GraphQLDirective.new do
    name        :include
    description 'Directs the executor to include this field or fragment only when the `if` argument is true.'

    arg :if, ! GraphQLBoolean, description: 'Included when true'

    on_operation  false
    on_fragment   true
    on_field      true
  end

  GraphQLSkipDirective = GraphQLDirective.new do
    name        :include
    description 'Directs the executor to skip this field or fragment only when the `if` argument is true.'

    arg :if, ! GraphQLBoolean, description: 'Skipped when true'

    on_operation  false
    on_fragment   true
    on_field      true
  end

end
