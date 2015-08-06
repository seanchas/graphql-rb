module GraphQL

  class GraphQLSchemaConfiguration < GraphQL::Configuration::Base

    slot :query,      GraphQLObjectType
    slot :mutation,   GraphQLObjectType, null: true

  end

  class GraphQLSchema < GraphQL::Configuration::Configurable

    configure_with GraphQLSchemaConfiguration

    def query_type
      @configuration.query
    end

    def mutation_type
      @configuration.mutation
    end

    def type_map
      # TODO: Add Introspection Schema
      @type_map ||= [query_type, mutation_type, Introspection::Schema__].reduce({}, &TypeMapReducer)
    end

    def type(name)
      type_map[name]
    end

  end

end
