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

    def initialize(configuration)
      super
      interfaces.each { |interface| interface.implement!(self) }
    end


    def field_map
      @field_map ||= @configuration.fields.reduce({}) { |memo, field| memo[field.name.to_sym] = field ; memo}
    end

    def field_names
      @field_names ||= field_map.keys
    end

    def fields
      @fields ||= field_map.values
    end

    def field(name)
      field_map[name.to_sym]
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
