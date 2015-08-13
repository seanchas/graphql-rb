module GraphQL
  module Language
    VariableDefinition = Struct.new('VariableDefinition', :variable, :type, :default_value) do


      def materialize(schema, param)
        schema_type = type.materialize(schema)

        if schema_type.nil? || !schema_type.is_a?(GraphQLInputType)
          raise GraphQLError, "Variable '#{variable.name}' expected value " +
            "of type '#{schema_type}' which cannot be used as input type."
        end

        if Validator.valid_value?(param, schema_type)
          if !param && default_value
            return default_value.materialize(schema_type)
          end
          return Validator.coerce_value(param, schema_type)
        end

        if param
          raise GraphQLError, "Variable '#{variable.name}' expected value " +
            "of type '#{schema_type}' but got '#{param}'."
        else
          raise GraphQLError, "Variable '#{variable.name}' " +
            "of required type '#{type}' was not provided."
        end

      end


    end
  end
end
