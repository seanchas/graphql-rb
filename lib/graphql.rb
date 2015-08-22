require 'graphql/errors'
require 'graphql/configuration'
require 'graphql/type'
require 'graphql/introspection'
require 'graphql/language'
require 'graphql/version'
require 'graphql/executor'
require 'graphql/validator'
require 'graphql/execution/worker'

module GraphQL

  def self.graphql(schema, query, root = nil, params = {}, operation = nil)
    document        = GraphQL::Language.parse(query)
    executor        = GraphQL::Executor.new(document, schema)
    result, errors  = executor.execute(root, params, operation)
    { data: result }.tap { |result| result[:errors] = errors unless errors.empty? }
  rescue StandardError => e
    { errors: [e] }
  end

end
