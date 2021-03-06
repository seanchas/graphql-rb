module GraphQL
  module Language
    SelectionSet = Struct.new("SelectionSet", :selections) do

      def empty?
        selections.empty?
      end

      # GraphQL Specification
      #   6.4.1 Field entries
      #     GetFieldEntry implementation
      #       objectType, object, - fields
      #         + context
      #
      #
      def evaluate(context, object_type, object, serially: false)
        grouped_fields = collect_fields(context, object_type)

        grouped_fields.reduce({}) do |memo, (key, fields)|

          field = fields.first

          field_definition = case
          when GraphQL::Introspection.meta_field?(field.name)
            GraphQL::Introspection.meta_field(field.name)
          else
            object_type.field(field.name)
          end

          unless field_definition.nil?
            context[:field_name] = field.name
            value = Execution::Pool.future do
              resolved_value  = field.resolve(context, object_type, object)
              resolved_value  = resolved_value.value if resolved_value.is_a?(Celluloid::Future)
              complete_value(context, field_definition.type, resolved_value, merge_selection_sets(fields))
            end

            memo[key.to_sym] = serially ? value.value : value
          end

          memo
        end
      end

      # GraphQL Specification
      #   6.3 Evaluate selection sets
      #     CollectFields implementation
      #       objectType, selectionSet = self, visitedFragments = []
      #         + context
      #
      def collect_fields(context, object_type, visited_fragments = [])
        memo = {}

        selections.each do |selection|

          case selection

          when Field
            # TODO: Directives
            (memo[selection.key] ||= []) << selection

          when FragmentSpread
            next if visited_fragments.include?(selection.name)

            visited_fragments << selection.name

            fragment = context[:document].fragment(selection.name)

            next if fragment.nil?

            next unless fragment.apply?(context, object_type)

            fragment.selection_set.collect_fields(context, object_type).each do |key, fields|
              memo[key] = (memo[key] ||= []).concat(fields)
            end

          when InlineFragment
            next unless selection.apply?(context, object_type)

            selection.selection_set.collect_fields(context, object_type).each do |key, fields|
              memo[key] = (memo[key] ||= []).concat(fields)
            end

          end

        end

        memo
      end

      # GraphQL Specification
      #   6.4.1 Field entries
      #     MergeSelectionSets implementations
      #       fields
      #
      def merge_selection_sets(fields)
        selections = fields.reduce([]) do |memo, field|
          memo.concat field.selection_set.selections unless field.selection_set.nil? || field.selection_set.empty?
          memo
        end

        SelectionSet.new(selections)
      end


      def complete_value(context, field_type, resolved_object, selection_set)
        return nil if resolved_object.nil?

        if resolved_object.is_a?(Exception)
          context[:errors] << "Field '#{field_type}' of '#{context[:field_name]}' error: '#{resolved_object}'."
          return nil
        end

        case field_type
        when GraphQLNonNull
          completed_object = complete_value(context, field_type.of_type, resolved_object, selection_set)
          raise "Field error: expecting non null value" if completed_object.nil?
          completed_object
        when GraphQLList
          resolved_object.map do |item|
            complete_value(context, field_type.of_type, item, selection_set)
          end
        when GraphQLScalarType, GraphQLEnumType
          field_type.serialize(resolved_object)
        when GraphQLObjectType, GraphQLInterfaceType, GraphQLUnionType
          field_type = field_type.resolve_type(resolved_object) if field_type.is_a?(GraphQLAbstractType)
          selection_set.evaluate(context, field_type, resolved_object)
        end

      end

    end
  end
end
