module GraphQL

  class GraphQLScalarType < GraphQLTypeBase

    attribute :name
    attribute :description
    attribute :coerce
    attribute :coerce_literal

    validate :name,           type: String
    validate :description,    type: String, allow_nil: true
    validate :coerce,         type: Proc
    validate :coerce_literal, type: Proc

    def coerce(value)
      @configuration.coerce.call(value)
    end

    def coerce_literal(ast)
      # TODO: check if ast is a GraphQLValue type
      @configuration.coerce_literal.nil? ? nil : @configuration.coerce_literal.call(ast)
    end

    def to_s
      name.to_s
    end

  end

end
