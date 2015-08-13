module GraphQL
  module Language
    Argument = Struct.new('Argument', :name, :value) do

      def materialize(field_argument_type, values)
        value.materialize(field_argument_type, values)
      end

    end
  end
end
