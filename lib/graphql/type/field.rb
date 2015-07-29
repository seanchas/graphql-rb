module GraphQL
  module Type


    class FieldDefinition

      extend Definable

      attr_definable :name,         -> (value) { value.is_a?(::String) }
      attr_definable :description,  -> (value) { value.is_a?(::String) }

    end


    class Field < Base

      configure_with FieldDefinition

    end


  end
end
