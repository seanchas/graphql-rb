module GraphQL

  # GraphQLDirectiveConfiguration
  #
  class GraphQLDirectiveConfiguration < GraphQL::Configuration::Base
    slot :name,           String, coerce: -> (v) { v.to_s }
    slot :args,           [-> { GraphQLArgument }], singular: :arg
    slot :description,    String, null: true
    slot :on_operation,   Object, coerce: -> (v) { !!v }
    slot :on_fragment,    Object, coerce: -> (v) { !!v }
    slot :on_field,       Object, coerce: -> (v) { !!v }
  end

  class GraphQLDirective < GraphQL::Configuration::Configurable
    configure_with GraphQLDirectiveConfiguration

    def arg_map
      @arg_map ||= @configuration.args.reduce({}) { |memo, arg| memo[arg.name.to_sym] = arg ; memo }
    end

    def arg_names
      @arg_names ||= arg_map.keys
    end

    def args
      @args ||= arg_map.values
    end

    def arg(name)
      arg_map(name.to_sym)
    end

  end

end

require_relative 'directives'
