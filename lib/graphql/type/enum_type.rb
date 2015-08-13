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

    def values
      @values ||= @configuration.values.reduce({}) do |memo, value|
        value.value       = value.name if value.value.nil?
        memo[value.name]  = value
        memo
      end
    end


    def serialize(value)
      values_by_value[value].name rescue nil
    end

    def parse_value(value)
      values[value.to_s].value rescue nil
    end

    def parse_literal(ast)
      ast[:kind] == :enum ? (values[ast[:value]].value rescue nil) : nil
    end

    def to_s
      name
    end

    private

    def values_by_value
      @values_by_value ||= begin
        values.reduce({}) do |memo, pair|
          name, value = pair
          memo[value.value] = value
          memo
        end
      end
    end

  end
end
