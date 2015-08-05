module GraphQL

  class GraphQLInterfaceTypeConfiguration < GraphQL::Configuration::Base
    slot :name,           String
    slot :fields,         [-> { GraphQLField }], singular: :field
    slot :resolve_type,   Proc,     null: true
    slot :description,    String,   null: true
  end

  class GraphQLInterfaceType < GraphQL::Configuration::Configurable

    include GraphQLType
    include GraphQLOutputType
    include GraphQLCompositeType
    include GraphQLAbstractType
    include GraphQLNullableType
    include GraphQLNamedType

    configure_with GraphQLInterfaceTypeConfiguration

    def initialize(configuration)
      super
      @impletentations = []
    end

    def fields
    end

    def possible_types
      @implementations
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
