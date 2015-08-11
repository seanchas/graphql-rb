module GraphQL
  module Language
    SelectionSet = Struct.new("SelectionSet", :selections) do

      def fields(object_type, visited_fragments = [])
        result = {}

        selections.each do |selection|
          case selection
          when Field
            (result[selection.key] ||= []) << selection
          end
        end

        result
      end

    end
  end
end
