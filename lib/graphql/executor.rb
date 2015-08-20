module GraphQL
  class Executor

    attr_reader :document, :schema, :context

    def initialize(document, schema)
      @document = document
      @schema   = schema
      @context  = {
        document:   document,
        schema:     schema,
        errors:     []
      }
    end

    def execute(root = {}, params = {}, operation_name = nil)
      raise GraphQLError, "At least one operation should be defined." if document.operations.size == 0
      raise GraphQLError, "Operation name should be defined for more than one operation." if document.operations.size > 1 && operation_name.nil?

      operation_name  = document.operations.first.name if operation_name.nil?
      operation       = document.operation(operation_name)

      raise GraphQLError, "Operation named '#{operation_name}' not found in document." if operation.nil?

      context[:root]    = root
      context[:params]  = params

      return materialize(operation.evaluate(context)), context[:errors]
    end

    def materialize(data)
      case data
      when Celluloid::Future
        materialize(data.value)
      when Hash
        data.reduce({}) do |memo, pair|
          memo[pair.first] = materialize(pair.last)
          memo
        end
      when Array
        data.each_with_index.reduce([]) do |memo, pair|
          memo[pair.last] = materialize(pair.first)
          memo
        end
      else
        data
      end
    end

  end
end
