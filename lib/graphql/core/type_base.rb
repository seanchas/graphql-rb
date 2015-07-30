require_relative './configuration'

module GraphQL
  class GraphQLTypeBase
    include GraphQL::GraphQLTypeConfiguration

    def self.should_validate!
      @should_validate = true
    end

    def self.should_validate?
      !!@should_validate
    end

    def initialize(configuration)
      @configuration = configuration
      validate! if self.class.should_validate?
    end

    def validate!
      raise 'Invalid' unless valid?
    end

  end
end
