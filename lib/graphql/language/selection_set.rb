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
      #         + context[schema, document]
      #
      # TODO: think of way to have error accessor at this point. Executor?
      #
      def evaluate(context, object_type, object)
        grouped_fields = collect_fields(context, object_type)

        #
        # TODO: Merge equal fields
        #

        grouped_fields.reduce({}) do |memo, (key, fields)|
          field       = fields.first
          field_type  = object_type.field(field.name).type rescue nil

          unless field_type.nil?
            resolve_context = context.merge({ parent_type: object_type })

            resolved_object   = field.resolve(context, object_type, object)
            selection_set     = merge_selection_sets(fields)
            memo[key.to_sym]  = Executor::FutureCompleter.complete_value(context, field_type, resolved_object, selection_set)
          end

          memo
        end
      end

      # GraphQL Specification
      #   6.3 Evaluate selection sets
      #     CollectFields implementation
      #       objectType, selectionSet = self, visitedFragments = []
      #         + context[schema, document]
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

    end
  end
end
