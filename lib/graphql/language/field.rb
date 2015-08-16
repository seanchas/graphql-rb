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
            context
        ]

        resolve   = object_type.field(name).resolve
        arguments = arguments.slice(0, resolve.arity) if resolve.arity >= 0

        resolve.call(*arguments)
      end


      def materialize_arguments(object_type, variables)
        schema_field = object_type.field(name)
        schema_field.args.reduce({}) do |memo, field_argument|
          argument = arguments.find { |argument| argument.name == field_argument.name }
          memo[argument.name.to_sym] = argument.materialize(field_argument.type, variables) unless argument.nil?
          memo
        end
      end

    end
  end
end
