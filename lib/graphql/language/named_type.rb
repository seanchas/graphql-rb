module GraphQL
  module Language
    NamedType = Struct.new('NamedType', :type) do

      def named_type
        type
      end

      def materialize(schema)
        schema.type(type)
      end

    end
  end
end
