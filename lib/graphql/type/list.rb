module GraphQL

  class GraphQLList

    attr_reader :of_type

    def initialize(of_type)
      # TODO: check if of_type is a GraphQL type
      @of_type = of_type
    end

    def to_s
      '[' + of_type.to_s + ']'
    end

  end

end
