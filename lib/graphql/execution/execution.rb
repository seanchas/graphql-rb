require 'celluloid/current'
require_relative 'executor'

module GraphQL
  module Execution

    def self.execute(schema, document, root, variables, operation)
      executor = Executor.new(schema, document, root, variables, operation)
      executor.perform!
    end

  end
end
