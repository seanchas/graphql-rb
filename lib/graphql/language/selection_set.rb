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
        memo = {}

        collect_fields(context, object_type).each do |key, fields|
          field_type = object_type.field(fields.first.name).type rescue nil

          next if field_type.nil?

          # NB: can throw
          begin
            resolved_object = fields.first.resolve(object_type, object)
          rescue Exception => e
            # TODO: Errors
            puts e
          end

          if resolved_object.nil?
            memo[key] = nil
          else
            # NB: can throw
            begin
              memo[key] = complete_value(context, field_type, resolved_object, merge_selection_sets(fields))
            rescue Exception => e
              # TODO: Errors
              puts e
            end
          end

        end

        memo
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
            puts "Got Field #{selection.key}"
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

      # GraphQL Specification
      #   6.4.1 Field entries
      #     CompleteValue implementation
      #       fieldType, result, subSelectionSet
      #         + context[schema, document]
      #
      def complete_value(context, field_type, resolved_object, sub_selection_set)
        if field_type.is_a?(GraphQLNonNull)
          completed_object = complete_value(context, field_type.of_type, resolved_object, sub_selection_set)
          raise "Field error: expecting non null value" if completed_object.nil?
          return completed_object
        end

        if field_type.is_a?(GraphQLList)
          return resolved_object.map { |item| complete_value(context, field_type.of_type, item, sub_selection_set) }
        end

        if field_type.is_a?(GraphQLScalarType) || field_type.is_a?(GraphQLEnumType)
          return field_type.coerce(resolved_object)
        end

        if field_type.is_a?(GraphQLObjectType) || field_type.is_a?(GraphQLInterfaceType) || field_type.is_a?(GraphQLUnionType)
          # NB: Missing Abstract type resolve in Specification
          field_type = field_type.resolve_type(resolved_object) if field_type.is_a?(GraphQLAbstractType)

          return sub_selection_set.evaluate(context, field_type, resolved_object)
        end
      end


    end
  end
end
