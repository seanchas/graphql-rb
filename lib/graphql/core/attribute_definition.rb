module GraphQL
  module GraphQLTypeAttributeDefinition

    def defined_attributes
      @defined_attributes ||= []
    end

    def define_attribute(name, type: nil, strategy: :overwrite, allow_null: false, &block)
      defined_attributes << name
      define_getter(name)
      define_setter(name, strategy)
      define_validator(name, type, strategy, allow_null, block)
    end

    private

    def define_setter(name, strategy)
      define_method "#{name}=" do |*args|
        next_value = args.first
        curr_value = public_send(name)

        next_value = case strategy
          when :concat then (curr_value || []).concat(next_value)
          when :merge then (curr_value || {}).merge(next_value)
          else next_value
        end

        instance_variable_set(:"@#{name}", next_value)
        public_send(name)
      end
    end

    def define_getter(name)
      define_method name do |*args|
        return public_send(:"#{name}=", *args) if args.size > 0
        instance_variable_get(:"@#{name}")
      end
    end

    def define_validator(name, type, strategy, allow_null, proc)
      define_method :"#{name}?" do
        value = public_send(name)
        return true if !!allow_null && value.nil?
        type_is_valid = type.nil? ? true : (type.is_a?(Proc) ? type.call(value) : value.is_a?(type))
        proc_is_valid = proc.nil? ? true : proc.call(value)
        instance_variable_defined?(:"@#{name}") && type_is_valid && proc_is_valid
      end
    end

  end
end
