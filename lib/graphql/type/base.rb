module GraphQL
  module Type

    class Base

      extend Configurable

      def initialize(config)
        @config = config
        validate!
      end

      def valid?
        @config.valid?
      end

      def validate!
        raise GraphQL::Error::ValidationError, "" unless valid?
      end

      def to_s
        @name
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
