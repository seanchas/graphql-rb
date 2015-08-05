module GraphQL

  class GraphQLInputObjectField < GraphQL::Configuration::Base
    slot :name,           String
    slot :type,           Object # GraphQLInputType
    slot :default_value,  Object,   null: true
    slot :description,    String,   null: true
  end

  class GraphQLInputObjectTypeConfiguration < GraphQL::Configuration::Base
    slot :name,           String
    slot :fields,         [GraphQLInputObjectField], singular: :field
    slot :description,    String,   null: true
  end

  class GraphQLInputObjectType < GraphQL::Configuration::Configurable

    include GraphQLType
    include GraphQLInputType
    include GraphQLNullableType
    include GraphQLNamedType

    configure_with GraphQLInputObjectTypeConfiguration

    def fields
      @fields ||= begin
        @configuration.fields.reduce({}) do |memo, field|
          memo[field.name] = field
          memo
        end
      end
    end

    def to_s
      name
    end
  end

end
