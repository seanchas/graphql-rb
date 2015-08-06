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
  end

end

require_relative 'directives'
