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

    def type
      @type ||= begin
        @configuration.type.is_a?(Proc) ? @configuration.type.call : @configuration.type
      end
    end
  end

end
