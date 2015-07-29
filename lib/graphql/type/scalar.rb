module GraphQL
  module Type

    class ScalarDefinition

      extend Definable

      attr_definable :name,           -> (value) { value.is_a?(::String) }
      attr_definable :description,    -> (value) { value.nil? || value.is_a?(::String) }
      attr_definable :coerce,         -> (value) { value.is_a?(::Proc) }
      attr_definable :coerceLiteral,  -> (value) { value.is_a?(::Proc) }

    end


    class Scalar < Base

      configure_with ScalarDefinition

      def coerce(value)
        @config.coerce.call(value)
      end

      def coerceLiteral(value)
        @config.coerceLiteral ? @config.coerceLiteral.call(value) : nil
      end

      def to_s
        @name
      end

    end

  end
end

require('graphql/type/scalars')
