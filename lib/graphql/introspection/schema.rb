module GraphQL

  module Introspection

    __Schema = GraphQLObjectType.new do

      name '__Schema'

      description   %(
                      A GraphQL Schema defines the capabilities of a GraphQL server. It exposes all available types and directives on
                      the server, as well as the entry points for query and mutation operations.
                    )

      field :types, -> { ! + ! __Type } do
        description 'A list of all types supported by this server.'
        resolve -> (schema) { schema.type_map.values }
      end

      field :query_type, -> { ! __Type } do
        description 'The type that query operations will be rooted at.'
        resolve -> (schema) { schema.query_type }
      end

      field :mutation_type, -> { ! __Type } do
        description 'If this server supports mutation, the type that mutation operations will be rooted at.'
        resolve -> (schema) { schema.query_type }
      end

      field :directives, -> { ! + ! __Type } do
        description 'A list of all directives supported by this server.'
        resolve -> (schema) { schema.directives }
      end

    end


    __Directive = GraphQLObjectType.new do

      name '__Directive'

      field :name, ! GraphQLString
      field :description, GraphQLString

      field :args, -> { ! + ! __InputValue } do
        resolve -> (directive) { directive.args }
      end

      field :on_operation,  ! GraphQLBoolean
      field :on_fragment,   ! GraphQLBoolean
      field :on_field,      ! GraphQLBoolean

    end


  end

end
