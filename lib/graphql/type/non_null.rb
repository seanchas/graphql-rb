module GraphQL

  class GraphQLNonNull

    include GraphQLType
    include GraphQLInputType
    include GraphQLOutputType

    NESTING_ERROR = 'Cannot nest NonNull inside NonNull'

    attr_reader :of_type

    def initialize(of_type)
      raise "Expecting #{GraphQLType}, got #{of_type.class}." unless of_type.is_a?(GraphQLType)
      raise NESTING_ERROR if of_type.is_a?(GraphQLNonNull)
      @of_type = of_type
    end

    def to_s
      of_type.to_s + '!'
    end

  end

end
