module GraphQL
  module Type

    module Configurable

      def configure_with(config_class)
        @config_class = config_class
      end

      def new(config = nil, &block)
        if config
          super
        else
          config = @config_class.new
          config.instance_eval(&block)
          super(config)
        end
      end

    end

  end
end
