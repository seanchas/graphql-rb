module GraphQL

  class GraphQLObjectTypeConfiguration < GraphQL::Configuration::Base
    slot :name,         String
    slot :interfaces,   [-> { GraphQLInterfaceType }],  null: true, singular: :interface
    slot :fields,       [-> { GraphQLField }],                      singular: :field
    slot :type_of?,     Proc,                           null: true
    slot :description,  String,                         null: true
  end


  class GraphQLObjectType < GraphQL::Configuration::Configurable

    include GraphQLType
    include GraphQLOutputType
    include GraphQLCompositeType
    include GraphQLNullableType
    include GraphQLNamedType

    configure_with GraphQLObjectTypeConfiguration

    def fields
    end

    def interfaces
      @configuration.interfaces
    end

    def type_of?(type)
      @configuration.type_of?.nil? ? false : @configuration.type_of?.call(type)
    end

    def to_s
      name
    end
  end

end
