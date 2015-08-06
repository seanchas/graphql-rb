module GraphQL

  # GraphQLArgument
  #
  class GraphQLArgument < GraphQL::Configuration::Base
    slot :name,           String, coerce: -> (v) { v.to_s }
    slot :type,           GraphQLInputType
    slot :default_value,  Object, null: true
    slot :description,    String, null: true
  end

end
