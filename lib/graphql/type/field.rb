module GraphQL

  # GraphQLArgument
  #
  class GraphQLField < GraphQL::Configuration::Base
    slot :name,                 String
    slot :type,                 Object # TODO: GraphQLOutputType
    slot :args,                 [ -> { GraphQLArgument } ]
    slot :resolve,              Proc
    slot :deprecation_reason,   String, null: true
    slot :description,          String, null: true
  end

end
