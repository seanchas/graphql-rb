module GraphQL
  module Type

    class ObjectDefinition

      extend Definable

      attr_definable :name, :description

    end

    class Object < Base

      configure_with ObjectDefinition

    end

  end
end
