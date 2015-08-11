module GraphQL
  module Language
    Field = Struct.new('Field', :alias, :name, :arguments, :directives, :selection_set) do

      def key
        self.alias || self.name
      end

    end
  end
end
