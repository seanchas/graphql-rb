module GraphQL

  class GraphQLObjectTypeConfiguration < GraphQL::Configuration::Base
    slot :name,         String
    slot :interfaces,   [-> { GraphQLInterfaceType }],  null: true
    slot :fields,       [-> { GraphQLField }]
    slot :type_of?,     Proc,                           null: true
    slot :description,  String,                         null: true
  end


  class GraphQLObjectType < GraphQL::Configuration::Configurable
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
