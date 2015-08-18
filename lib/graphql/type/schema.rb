module GraphQL

  class GraphQLSchemaConfiguration < GraphQL::Configuration::Base

    slot :name,       String
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
      @type_map ||= [query_type, mutation_type, Introspection::Schema__].reduce({}, &TypeMapReducer)
    end

    def type_names
      @type_names ||= type_map.keys
    end

    def types
      @types ||= type_map.values
    end

    def type(name)
      type_map[name]
    end

    def to_s
      name
    end

  end

end
