module GraphQL
  module Language
    Field = Struct.new('Field', :alias, :name, :arguments, :directives, :selection_set) do

      def self.entry(key, type, object, fields, context)
        return nil unless field_definition = type.fields[fields.first.name]
        
      end

      def key
        self.alias || self.name
      end

      def resolve(type, root)
        return nil unless field_definition = type.fields[name]
        result = field_definition.resolve.call(root, {}, {})
      end

    end
  end
end
