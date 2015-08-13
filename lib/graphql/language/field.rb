module GraphQL
  module Language
    Field = Struct.new('Field', :alias, :name, :arguments, :directives, :selection_set) do

      # GraphQL Specification
      #   6.3 Evaluate selection sets
      #     CollectFields
      #       responseKey implementation
      #
      def key
        self.alias || self.name
      end

      # GraphQL Specification
      #   6.4.1 Field entries
      #     ResolveFieldOnObject implementation
      #       objectType, object, firstField = self
      #         + context[document, schema, root]
      #
      # TODO: think of way to have defined arguments at this point. Validator?
      # TODO: think of some kind of context to pass through as third parameter
      # TODO: think of should or shouldn't we pass self as fourth parameter
      #
      def resolve(context, object_type, object)
        object_type.field(name).resolve(object, prepare_arguments(context[:params]), context[:root])
      end

      def prepare_arguments(params)
        arguments.reduce({}) do |memo, argument|
          key = argument.name.to_sym

          case argument.value
          when Variable
            memo[key] = params[key]
          when Value
            memo[key] = argument.value.value
          end

          memo
        end
      end

    end
  end
end
