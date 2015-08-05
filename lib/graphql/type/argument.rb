module GraphQL

  # GraphQLArgument
  #
  class GraphQLArgument < GraphQL::Configuration::Base
    slot :name,           String
    slot :type,           Object # TODO: GraphQLInputType
    slot :default_value,  Object, null: true
    slot :description,    String, null: true
  end

end
