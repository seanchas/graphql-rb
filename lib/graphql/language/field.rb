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
        object_type.field(name).resolve.nil? ? default_resolve(object) : object_type.field(name).resolve.call(object, self.arguments)
      end

      def default_resolve(object)
        object.public_send(name, *arguments)
      end

    end
  end
end
