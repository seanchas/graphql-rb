module GraphQL

  ###
  #
  # == GraphQLEnum Definition
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
  #     values({
  #       'RED'   => GraphQL::GraphQLEnumValue.new(name: 'RED',   value: 0),
  #       'GREEN' => GraphQL::GraphQLEnumValue.new(name: 'GREEN', value: 1),
  #       'BLUE'  => GraphQL::GraphQLEnumValue.new(name: 'BLUE',  value: 2),
  #       'ALPHA' => GraphQL::GraphQLEnumValue.new(name: 'ALPHA', description: 'Alpha channel')
  #     })
  #   end
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
  # Note: Value name will be converted into string
  #
  # Note: If a value is not provided in a definition, the name of the enum value
  # will be used as it's internal value.
  #
  ###


  class GraphQLEnumValue < GraphQLTypeBase

    attribute :name,                type: String
    attribute :description,         type: String, allow_null: true
    attribute :value,                             allow_null: true
    attribute :deprecation_reason,  type: String, allow_null: true

    should_validate!

  end


  class GraphQLEnumConfiguration < GraphQLTypeConfiguration::Base
    attribute :name,        type: String
    attribute :description, type: String, allow_null: true
    attribute :values

    def values?
      values.is_a?(Hash) && values.size > 0 && values.all? { |key, value| key.is_a?(String) && value.is_a?(GraphQLEnumValue) }
    end

    def value(value_name, value_value = nil, value_options = {})
      value_name = value_name.to_s if value_name.is_a?(Symbol)
      (self.values ||= {})[value_name] = GraphQLEnumValue.new(value_options.merge({ name: value_name, value: value_value }))
    end
  end

  class GraphQLEnum < GraphQLTypeBase

    configuration GraphQLEnumConfiguration

    should_validate!

    def values
      @values ||= begin
        @configuration.values.reduce({}) do |memo, pair|
          name, value   = pair
          name          = name.to_s
          value.name    = name
          value.value   = name if value.value.nil?
          memo[name]    = value
          memo
        end
      end
    end

    def coerce(value)
      values_by_value[value].name rescue nil
    end

    def coerce_literal(ast)
      if ast[:kind] == :enum
        values[ast[:value]].value rescue nil
      end
    end

    def to_s
      name
    end

  private

    def values_by_value
      @values_by_value ||= begin
        values.reduce({}) do |memo, pair|
          value = pair.last
          memo[value.value] = value
          memo
        end
      end
    end

  end

end
