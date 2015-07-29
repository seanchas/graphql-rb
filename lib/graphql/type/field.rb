module GraphQL
  module Type


    class FieldDefinition

      extend Definable

      attr_definable :name, :description

    end


    class Field < Base

      configure_with FieldDefinition

    end


  end
end
