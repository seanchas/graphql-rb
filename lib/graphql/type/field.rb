module GraphQL
  module Type


    class FieldDefinition

      extend  Definable

      attr_definable :name, -> (value) { value.is_a?(::String) }
      attr_definable :description, -> (value) { value.nil? || value.is_a?(::String) }
      attr_definable :type, -> (value) { GraphQL::Type.output_type?(value) }
      attr_definable :args, -> (value) { value.nil? || (value.is_a?(::Array) && value.all? { |arg| arg.is_a?(GraphQL::Argument) }) }, :concat
      attr_definable :resolve, -> (value) { value.nil? || value.is_a?(::Proc) }
      attr_definable :deprecation_reason, -> (value) { value.nil? || value.is_a?(::String) }

      def arg(name, type, description: nil, default_value: nil)
        args GraphQL::Attribute.new do
          name            name
          description     description
          type            type
          default_value   default_value
        end
      end

    end


    class Field < Base

      configure_with FieldDefinition

    end


  end
end
