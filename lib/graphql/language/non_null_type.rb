module GraphQL
  module Language
    NonNullType = Struct.new('NonNullType', :type) do

      def named_type
        type.respond_to?(:named_type) ? type.named_type : type
      end

      def materialize(schema)
        GraphQLNonNull.new(type.materialize(schema))
      end

    end
  end
end
