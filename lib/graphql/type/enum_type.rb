module GraphQL

  #
  # == GraphQLEnumType Definition
  #
  # Some leaf values of requests and input values are Enums. GraphQL serializes
  # Enum values as strings, however internally Enums can be represented by any
  # kind of type, often integers.
  #
  # Examples:
  #
  #   RGBAType = GraphQLEnum.new do
  #     name  'RGBA'
  #
  #     value :RED,   0
  #     value :GREEN, 1
  #     value :BLUE,  2
  #     value :ALPHA, description: 'Alpha channel'
  #   end
  #
  # Note: If a value is not provided in a definition, the name of the enum value
  # will be used as it's internal value.
  #


  # GraphQLEnumValueConfiguration
  #
  class GraphQLEnumValue < GraphQL::Configuration::Base
    slot :name,                 String, coerce: -> (v) { v.to_s }
    slot :value,                Object, null: true
    slot :description,          String, null: true
    slot :deprecation_reason,   String, null: true
  end


  # GraphQLEnumTypeConfiguration
  #
  class GraphQLEnumTypeConfiguration < GraphQL::Configuration::Base
    slot :name,         String
    slot :values,       [GraphQLEnumValue], singular: :value
    slot :description,  String,             null: true
  end


  # GraphQLEnumType
  #
  class GraphQLEnumType < GraphQL::Configuration::Configurable

    include GraphQLType
    include GraphQLInputType
    include GraphQLOutputType
    include GraphQLLeafType
    include GraphQLNullableType
    include GraphQLNamedType

    configure_with GraphQLEnumTypeConfiguration


    def value_map
      @value_map ||= @configuration.values.reduce({}) do |memo, value|
        value.value = value.name if value.value.nil?
        memo[value.name.to_sym] = value
        memo
      end
    end

    def value_map_by_values
      @value_map_by_values ||= values.reduce({}) { |memo, value| memo[value.value.to_s] = value ; memo }
    end

    def value_names
      @value_names ||= value_map.keys
    end

    def values
      @values ||= value_map.values
    end

    def value(name)
      value_map[name.to_sym]
    end

    def serialize(v)
      value_map_by_values[v.to_s].name rescue nil
    end

    def parse_value(v)
      value(v).value rescue nil
    end

    def parse_literal(ast)
      value(ast[:value]).value rescue nil if ast[:kind] == :enum
    end

    def to_s
      name
    end

  end
end
