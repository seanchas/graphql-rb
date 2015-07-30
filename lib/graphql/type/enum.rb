module GraphQL

  class GraphQLEnumValue < GraphQLTypeBase

    attribute :name,                type: String
    attribute :description,         type: String, allow_null: true
    attribute :value
    attribute :deprecation_reason,  type: String, allow_null: true

    should_validate!

  end

  class GraphQLEnum < GraphQLTypeBase
  end

end
