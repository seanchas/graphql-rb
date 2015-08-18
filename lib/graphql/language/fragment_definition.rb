module GraphQL
  module Language
    FragmentDefinition = Struct.new('FragmentDefinition', :name, :type_condition, :directives, :selection_set) do

      # GraphQL Specification
      #   6.3 Evaluating selection sets
      #     doesFragmentTypeApply implementation
      #       objectType, fragmentType = self.type_condition => Schema.type
      #         + context[schema, document]
      #
      def apply?(context, object_type)
        type = context[:schema].type(type_condition.type)

        return type == object_type if type.is_a?(GraphQLObjectType)

        return type.possible_type?(object_type) if type.is_a?(GraphQLInterfaceType)

        return type.possible_type?(object_type) if type.is_a?(GraphQLUnionType)
      end

    end
  end
end
