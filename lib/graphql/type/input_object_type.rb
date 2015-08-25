module GraphQL

  class GraphQLInputObjectField < GraphQL::Configuration::Base
    slot :name,           String,   coerce: -> (v) { v.to_s }
    slot :type,           GraphQLInputType
    slot :default_value,  Object,   null: true
    slot :description,    String,   null: true
  end

  class GraphQLInputObjectTypeConfiguration < GraphQL::Configuration::Base
    slot :name,           String,   coerce: -> (v) { v.to_s }
    slot :fields,         [GraphQLInputObjectField], singular: :field
    slot :description,    String,   null: true
  end

  class GraphQLInputObjectType < GraphQL::Configuration::Configurable

    include GraphQLType
    include GraphQLInputType
    include GraphQLNullableType
    include GraphQLNamedType

    configure_with GraphQLInputObjectTypeConfiguration


    def field_map
      @field_map ||= @configuration.fields.reduce({}) { |memo, field| memo[field.name.to_sym] = field ; memo }
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

    def to_s
      name
    end
  end

end
