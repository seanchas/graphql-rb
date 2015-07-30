module GraphQL
  module GraphQLTypeAttributeValidation

    def validations
      @validations ||= {}
    end

    def validate_attribute(name, type: nil, allow_nil: false, &block)
      validations[name] = -> (value) {
        return true if allow_nil && value.nil?
        type_is_valid = type.nil? ? true : value.is_a?(type)
        block_is_valid = block_given? ? block.call(value) : true
        type_is_valid && block_is_valid
      }
    end

  end
end
