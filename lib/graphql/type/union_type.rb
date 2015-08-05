module GraphQL

  class GraphQLUnionTypeConfiguration < GraphQL::Configuration::Base
    slot :name,           String
    slot :types,          [-> { GraphQLObjectType }], singular: :type
    slot :resolve_type,   Proc,     null: true
    slot :description,    String,   null: true
  end

  class GraphQLUnionType < GraphQL::Configuration::Configurable

    include GraphQLType
    include GraphQLOutputType
    include GraphQLCompositeType
    include GraphQLAbstractType
    include GraphQLNullableType
    include GraphQLNamedType

    configure_with GraphQLUnionTypeConfiguration

    def possible_types
      @configuration.types
    end

    def possible_type?(type)

    end

    def resolve_type(type)
      @configuration.resolve_type.nil? ? nil : @configuration.resolve_type.call(type)
    end

    def to_s
      name
    end

  end

end
