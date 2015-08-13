require 'celluloid/current'
require 'singleton'

module GraphQL
  class Executor

    class FutureCompleter
      include Celluloid
      include Singleton

      def self.complete_value(context, field_type, resolved_object, selection_set)
        completer = resolved_object.is_a?(Celluloid::Future) ? instance.future : instance
        completer.complete_value(context, field_type, resolved_object, selection_set)
      end

      def complete_value(context, field_type, resolved_object, selection_set)
        return nil if resolved_object.nil?

        resolved_object = resolved_object.value if resolved_object.is_a?(Celluloid::Future)

        case field_type
        when GraphQLNonNull
          completed_object = FutureCompleter.complete_value(context, field_type.of_type, resolved_object, selection_set)
          raise "Field error: expecting non null value" if completed_object.nil?
          completed_object
        when GraphQLList
          resolved_object.map do |item|
            FutureCompleter.complete_value(context, field_type.of_type, item, selection_set)
          end
        when GraphQLScalarType, GraphQLEnumType
          field_type.serialize(resolved_object)
        when GraphQLObjectType, GraphQLInterfaceType, GraphQLUnionType
          field_type = field_type.resolve_type(resolved_object) if field_type.is_a?(GraphQLAbstractType)
          selection_set.evaluate(context, field_type, resolved_object)
        end

      end
    end

    attr_reader :document, :schema, :context

    def initialize(document, schema)
      @document = document
      @schema   = schema
      @context  = {
        document:   document,
        schema:     schema
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

      operation.prepare_variables!(context)
      materialize(operation.evaluate(context))
    end

    def materialize(data)
      case data
      when Hash
        data.each do |key, value|
          data[key] = value.value if value.is_a?(Celluloid::Future)
          materialize(data[key])
        end
      when Array
        data.each_with_index do |value, i|
          data[i] = value.value if value.is_a?(Celluloid::Future)
          materialize(data[i])
        end
      end
      data
    end

  end
end
