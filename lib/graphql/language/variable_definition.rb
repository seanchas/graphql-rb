module GraphQL
  module Language
    VariableDefinition = Struct.new('VariableDefinition', :variable, :type, :default_value) do

      def value(context)
        @value ||= begin
          schema_type     = context[:schema].type(type.named_type)
          type_for_schema = "type '#{type.named_type}' for schema '#{context[:schema].name}'"

          if schema_type.nil?
            puts "Unknown #{type_for_schema}."
            return nil
          end

          unless schema_type.is_a?(GraphQLInputType)
            puts "Not an input #{type_for_schema}."
            return nil
          end

          value_from_params = context[:params][variable.name.to_sym]

          unless value_from_params.nil?
            value = schema_type.coerce(value_from_params)
            if value.nil?
              puts "Cannot coerce provided value '#{value_from_params}' for #{type_for_schema}."
              return nil
            end
          else
            value = schema_type.coerce_literal(default_value)
            if value.nil?
              puts "Cannot coerce default value '#{default_value.value}' for #{type_for_schema}."
              return nil
            end
          end

          value
        end
      end

    end
  end
end
