module GraphQL
  module Language
    Variable = Struct.new('Variable', :name) do

      def materialize(type, variables)
        variables[name.to_sym]
      end

    end
  end
end
