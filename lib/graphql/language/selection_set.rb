module GraphQL
  module Language
    SelectionSet = Struct.new("SelectionSet", :selections) do

      def fields(object_type, visited_fragments = [])
        result = {}

        selections.each do |selection|
          case selection
          when Field
            # TODO: @skip directive
            # TODO: @include directive
            (result[selection.key] ||= []) << selection
          # TODO: Fragment Spreade
          # TODO: Inline Fragment
          end
        end

        result
      end

    end
  end
end
