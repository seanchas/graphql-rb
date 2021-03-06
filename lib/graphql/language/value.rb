module GraphQL
  module Language
    Value = Struct.new('Value', :kind, :value) do


      def materialize(type, variables)
        case type
        when GraphQLNonNull
          materialize(type.of_type, variables)
        when GraphQLList
          value.map { |value| value.materialize(type.of_type, variables) }
        when GraphQLInputObjectType
          type.fields.reduce({}) do |memo, field|
            value_for_field     = value.find { |v| v[:name] == field.name }[:value]
            materialized_value  = value_for_field.materialize(field.type, variables)
            materialized_value  = field.default_value if materialized_value.nil?
            memo[field.name.to_sym] = materialized_value unless materialized_value.nil?
            memo
          end
        when GraphQLScalarType, GraphQLEnumType
          type.parse_literal(self)
        else
          raise "Must be input type"
        end
      end


    end
  end
end
