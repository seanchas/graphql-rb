module GraphQL
  module Type


    class FieldDefinition

      extend  Definable

      attr_definable :name,               -> (value) { value.is_a?(::String) }
      attr_definable :description,        -> (value) { value.nil? || value.is_a?(::String) }
      attr_definable :type,               -> (value) { GraphQL::Type.output_type?(value) }
      attr_definable :args,               -> (value) { value.is_a?(::Array) }
      attr_definable :resolve,            -> (value) { value.nil? || value.is_a?(::Proc) }
      attr_definable :deprecation_reason, -> (value) { value.nil? || value.is_a?(::String) }

    end


    class Field < Base

      configure_with FieldDefinition

    end


  end
end
