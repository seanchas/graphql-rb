module GraphQL
  module Language
    ListType = Struct.new('ListType', :type) do

      def named_type
        type.respond_to?(:named_type) ? type.named_type : type
      end

      def materialize(schema)
        GraphQLList.new(type.materialize(schema))
      end

    end
  end
end
