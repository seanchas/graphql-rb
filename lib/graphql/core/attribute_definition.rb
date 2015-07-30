module GraphQL
  module GraphQLTypeAttributeDefinition

    def defined_attributes
      @defined_attributes ||= []
    end

    def define_attribute(name, strategy: :overwrite)
      defined_attributes << name

      ivar_name     = :"@#{name}"
      getter_name   = :"#{name}"
      setter_name   = :"#{name}="

      define_method "#{name}=" do |*args|
        next_value = args.first
        curr_value = public_send(getter_name)

        next_value = case strategy
          when :concat then (curr_value || []).concat(next_value)
          when :merge then (curr_value || {}).merge(next_value)
          else next_value
        end

        instance_variable_set(ivar_name, next_value)
        public_send(getter_name)
      end

      define_method name do |*args|
        return public_send(setter_name, *args) if args.size > 0
        instance_variable_get(ivar_name)
      end
    end

  end
end
