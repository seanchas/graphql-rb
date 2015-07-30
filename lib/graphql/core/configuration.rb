require_relative './attribute_definition'
require_relative './attribute_validation'

module GraphQL
  module GraphQLTypeConfiguration

    def self.included(base)
      base.extend(ClassMethods)
    end


    def valid?
      @configuration.class.validations.all? do |name, proc|
        proc.call(@configuration.send(name))
      end
    end


    def method_missing(name, *args, &block)
      if @configuration.class.defined_attributes.include?(name)
        @configuration.send(name, *args, &block)
      else
        super
      end
    end


    module ClassMethods

      def configuration
        @configuration_class ||= Class.new do
          extend GraphQL::GraphQLTypeAttributeDefinition
          extend GraphQL::GraphQLTypeAttributeValidation


          def initialize(options = {})
            extend(options)
          end

          def extend(options = {})
            options.each { |key, value| send(key, value) }
            self
          end
        end
      end

      def attribute(*args, &block)
        self.configuration.define_attribute(*args, &block)
      end


      def validate(*args, &block)
        self.configuration.validate_attribute(*args, &block)
      end


      def new(*args, &block)
        configuration   = args.first if args.first.is_a?(self.configuration)
        options         = args.last.is_a?(::Hash) ? args.last : {}

        if configuration
          super(configuration.extend(options))
        else
          configuration = self.configuration.new(options)
          configuration.instance_eval(&block) if block_given?
          super(configuration)
        end
      end

    end


  end
end
