module GraphQL
  module Type

    class ObjectDefinition

      extend Definable

      attr_definable :name,         -> (value) { value.is_a?(::String) }
      attr_definable :description,  -> (value) { value.nil? || value.is_a?(::String) }

    end

    class Object < Base

      configure_with ObjectDefinition

    end

  end
end
