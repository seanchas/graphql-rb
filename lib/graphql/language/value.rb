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
          raise "Not. Implemented. Yet."
        when GraphQLScalarType, GraphQLEnumType
          type.parse_literal(self)
        else
          raise "Must be input type"
        end
      end


    end
  end
end
