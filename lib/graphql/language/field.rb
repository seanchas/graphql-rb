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
      # TODO: think of should or shouldn't we pass self as fourth parameter
      #
      def resolve(context, object_type, object)
        arguments = [
            object,
            materialize_arguments(object_type, context[:variables]),
            context.merge(parent_type: object_type)
        ]

        resolve   = schema_field(object_type).resolve
        arguments = arguments.slice(0, resolve.arity) if resolve.arity >= 0

        resolve.call(*arguments)
      end


      def materialize_arguments(object_type, variables)
        schema_field(object_type).args.reduce({}) do |memo, field_argument|
          argument = arguments.find { |argument| argument.name == field_argument.name }
          memo[argument.name.to_sym] = argument.materialize(field_argument.type, variables) unless argument.nil?
          memo
        end
      end


      def schema_field(object_type)
        case
        when GraphQL::Introspection.meta_field?(name)
          GraphQL::Introspection.meta_field(name)
        else
          object_type.field(name)
        end
      end

    end
  end
end
