module GraphQL

  # GraphQLFieldConfiguration
  #
  class GraphQLFieldConfiguration < GraphQL::Configuration::Base
    slot :name,                 String, coerce: -> (v) { v.to_s }
    slot :type,                 -> { GraphQLOutputType }
    slot :args,                 [ -> { GraphQLArgument } ], singular: :arg
    slot :resolve,              Proc
    slot :deprecation_reason,   String, null: true
    slot :description,          String, null: true
  end

  # GraphQLField
  #
  class GraphQLField < GraphQL::Configuration::Configurable
    configure_with GraphQLFieldConfiguration

    DEFAULT_RESOLVE = lambda { |name|
      lambda { |object|
        object.public_send(name)
      }
    }

    def type
      @type ||= @configuration.type.is_a?(Proc) ? @configuration.type.call : @configuration.type
    end

    def args
      @args ||= @configuration.args
    end

    def resolve
      @configuration.resolve || DEFAULT_RESOLVE.call(name)
    end
  end

end
