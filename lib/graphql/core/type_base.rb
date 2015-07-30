require_relative './configuration'

module GraphQL
  class GraphQLTypeBase
    include GraphQL::GraphQLTypeConfiguration

    def initialize(configuration)
      @configuration = configuration
    end

  end
end
