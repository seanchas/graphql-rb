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
      @config.coerce(value)
    end

    def coerse_literal(ast)
      # TODO: check if ast is a GraphQLValue type
      @config.coerce_literal.call(ast) rescue nil
    end

  end

end
