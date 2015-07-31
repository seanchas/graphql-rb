module GraphQL

  class GraphQLScalarType < GraphQLTypeBase

    attribute :name,            type: String
    attribute :description,     type: String, allow_null: true
    attribute :coerce,          type: Proc
    attribute :coerce_literal,  type: Proc

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

  # String
  #
  GraphQLString = GraphQLScalarType.new do
    name 'String'

    coerce -> (value) {
      value.to_s
    }

    coerce_literal -> (ast) {
      ast[:kind] == :string ? ast[:value] : nil
    }
  end


end
