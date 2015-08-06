require_relative 'configuration'

module GraphQL
  module Configuration

    class Configurable


      def initialize(configuration)
        @configuration = configuration
      end


      def method_missing(name, *args, &block)
        if @configuration.respond_to?(name)
          @configuration.send(name, *args, &block)
        else
          super
        end
      end


      def self.new(*args, &block)
        if args.size == 1 && !block_given? && args.first.is_a?(Base)
          super args.first
        else
          configuration = self.configuration.new(*args, &block)
          super(configuration)
        end
      end


      def self.configuration
        @configuration
      end


      def self.configure_with(configuration)
        raise RuntimeError.new("Configuration should be descendant of #{Slots}.") unless configuration < Base
        @configuration = configuration
      end

    end

  end
end
