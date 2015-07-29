module GraphQL
  module Type

    class Base

      extend Configurable

      attr_reader :name, :description

      def initialize(config)
        @name         = config.name
        @description  = config.description
        @config       = config
        validate!
      end

      def valid?
        name.is_a?(::String) && (description == nil || description.is_a?(::String))
      end

      def validate!
        raise GraphQL::Error::ValidationError, "" unless valid?
      end

      def method_missing(name, *args, &block)
        if @config.respond_to?(name)
          @config.public_send(name, *args, &block)
        else
          super
        end
      end

    end

  end
end
