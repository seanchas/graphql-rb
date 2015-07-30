module GraphQL

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
      (self.values ||= {})[name] = GraphQLEnumValue.new(value_options.merge({ name: value_name, value: value_value }))
    end
  end

  class GraphQLEnum < GraphQLTypeBase

    configuration GraphQLEnumConfiguration

    should_validate!

    def values

    end

    def coerce(value)

    end

    def coerce_literal(ast)

    end

    def to_s
      name
    end

  end

end
