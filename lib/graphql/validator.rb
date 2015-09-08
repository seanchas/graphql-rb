module GraphQL
  class Validator

    def self.coerce_value(value, type)
      case type
      when GraphQLNonNull
        coerce_value(value, type.of_type)
      when value.nil?
        nil
      when GraphQLList
        values = value.is_a?(Array) ? value : [value]
        values.map { |value| coerce_value(value, type.of_type) }
      when GraphQLInputObjectType
        type.fields.reduce({}) do |memo, field|
          memo[field.name.to_sym] = coerce_value(value[field.name], field.type)
          memo
        end
      when GraphQLScalarType, GraphQLEnumType
        type.parse_value(value)
      else
        raise "Must be input type"
      end
    end

    def self.valid_value?(value, type)
      case type
      when GraphQLNonNull
        return false if value.nil?
        valid_value?(value, type.of_type)
      when value.nil?
        true
      when GraphQLList
        values = value.is_a?(Array) ? value : [value]
        values.all? { |value| valid_value?(value, type.of_type) }
      when GraphQLInputObjectType
        return type.fields.all? { |field| valid_value?(value[field.name], field.type) }
      when GraphQLScalarType, GraphQLEnumType
        !type.parse_value(value).nil?
      else
        raise "Must be input type"
      end
    end


  end
end
