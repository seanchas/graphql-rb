require 'graphql/errors'
require 'graphql/configuration'
require 'graphql/type'
require 'graphql/introspection'
require 'graphql/language'
require 'graphql/version'
require 'graphql/executor'
require 'graphql/validator'

module GraphQL

  def self.graphql(schema, query, root, params, operation = nil)
    document  = GraphQL::Language.parse(query)
    executor  = GraphQL::Executor.new(document, schema)
    result    = executor.execute(root, params, operation)
    { data: result }
  rescue StandardError => e
    { errors: [e] }
  end

end
