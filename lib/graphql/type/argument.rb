module GraphQL


  class ArgumentDefinition

    extend GraphQL::Type::Definable

    attr_definable :name,           -> (value) { value.is_a?(::String) }
    attr_definable :description,    -> (value) { value.nil? || value.is_a?(::String) }
    attr_definable :type,           -> (value) { GraphQL::Type.input_type?(value) }
    attr_definable :default_value,  -> (value) { true }

  end


  class Argument < GraphQL::Type::Base

    configure_with ArgumentDefinition

  end

end
