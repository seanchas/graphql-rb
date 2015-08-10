module GraphQL
  module Language

    SelectionSet = Struct.new("SelectionSet", :selections) do

      def fields(memo = {})
        selections.reduce(memo) do |memo, selection|
          case selection
          when Field
            (memo[selection.key] ||= []) << selection
          # Inline Fragment
          # Fragment Spread
          end
          memo
        end
      end

    end

  end
end
