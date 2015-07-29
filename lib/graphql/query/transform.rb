module GraphQL
  module Query

    class Transform < Parslet::Transform

      def self.nil_or_hash_to_array(value)
        case value
        when Array  then  value
        when Hash   then  [value]
        else              []
        end
      end

      rule(
        field_name:       simple(:name),
        field_arguments:  subtree(:arguments),
        field_selections: subtree(:selections)
      ) {

        {
          kind:         :field,
          name:         name.to_s,
          arguments:    GraphQL::Query::Transform.nil_or_hash_to_array(arguments),
          selections:   GraphQL::Query::Transform.nil_or_hash_to_array(selections)
        }
      }

      # Argument
      #
      rule(
        argument_name: simple(:name),
        argument_value: simple(:value),
      ) {
        {
          kind:   :argument,
          name:   name.to_s,
          value:  value.to_s
        }
      }

      # String
      #
      rule(
        string: simple(:value)
      ) {
        value
      }
    end

  end
end
